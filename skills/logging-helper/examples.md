# Logging Helper - Real-World Examples

This document contains real-world examples of adding logging to various types of code.

## Table of Contents

- [Web API Handler](#web-api-handler)
- [Database Operation](#database-operation)
- [Background Job](#background-job)
- [Payment Processing](#payment-processing)
- [Authentication Flow](#authentication-flow)
- [Error Handling](#error-handling)
- [Performance Monitoring](#performance-monitoring)

---

## Web API Handler

### Before (No Logging)

```javascript
app.post('/api/orders', async (req, res) => {
  const { userId, items } = req.body;
  const order = await Order.create({ userId, items });
  await processPayment(order);
  await sendConfirmation(order);
  res.json(order);
});
```

### After (With Logging)

```javascript
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [new winston.transports.Console()]
});

app.post('/api/orders', async (req, res) => {
  const requestId = req.headers['x-request-id'] || uuid();
  const { userId, items } = req.body;

  logger.info('order_creation_started', {
    request_id: requestId,
    user_id: userId,
    item_count: items.length
  });

  try {
    const order = await Order.create({ userId, items });

    logger.info('order_created', {
      request_id: requestId,
      order_id: order.id,
      total: order.total
    });

    await processPayment(order);

    logger.info('payment_processed', {
      request_id: requestId,
      order_id: order.id,
      amount: order.total
    });

    await sendConfirmation(order);

    logger.info('order_completed', {
      request_id: requestId,
      order_id: order.id,
      user_id: userId
    });

    res.json(order);

  } catch (error) {
    logger.error('order_creation_failed', {
      request_id: requestId,
      user_id: userId,
      error: error.message,
      error_code: error.code,
      stack: error.stack
    });
    res.status(500).json({ error: 'Order creation failed' });
  }
});
```

**Logs produced:**
```json
{"level":"info","timestamp":"2025-01-08T10:30:00Z","message":"order_creation_started","request_id":"abc-123","user_id":42,"item_count":3}
{"level":"info","timestamp":"2025-01-08T10:30:01Z","message":"order_created","request_id":"abc-123","order_id":999,"total":199.99}
{"level":"info","timestamp":"2025-01-08T10:30:02Z","message":"payment_processed","request_id":"abc-123","order_id":999,"amount":199.99}
{"level":"info","timestamp":"2025-01-08T10:30:03Z","message":"order_completed","request_id":"abc-123","order_id":999,"user_id":42}
```

---

## Database Operation

### Before

```python
async def get_user_orders(user_id: int) -> List[Order]:
    orders = await db.query(
        "SELECT * FROM orders WHERE user_id = $1",
        user_id
    )
    return orders
```

### After

```python
import structlog

logger = structlog.get_logger()

async def get_user_orders(user_id: int) -> List[Order]:
    logger.debug("fetching_user_orders", user_id=user_id)

    try:
        orders = await db.query(
            "SELECT * FROM orders WHERE user_id = $1",
            user_id
        )

        logger.info(
            "user_orders_fetched",
            user_id=user_id,
            order_count=len(orders),
            query_time_ms=duration
        )

        return orders

    except Exception as e:
        logger.error(
            "database_query_failed",
            user_id=user_id,
            error=str(e),
            error_type=type(e).__name__
        )
        raise
```

---

## Background Job

### Before

```ruby
class ProcessImportJob < ApplicationJob
  def perform(file_path)
    data = CSV.read(file_path)
    data.each do |row|
      Product.create!(row.to_h)
    end
  end
end
```

### After

```ruby
class ProcessImportJob < ApplicationJob
  def perform(file_path)
    @job_id = job_id
    @start_time = Time.now

    log_info("import_job_started", file_path: file_path)

    data = CSV.read(file_path)
    log_info("csv_read", row_count: data.count)

    success_count = 0
    error_count = 0

    data.each_with_index do |row, index|
      begin
        Product.create!(row.to_h)
        success_count += 1

        if index % 100 == 0
          log_debug("import_progress",
            processed: index,
            total: data.count,
            success: success_count,
            errors: error_count
          )
        end
      rescue => e
        error_count += 1
        log_warn("row_import_failed",
          row_index: index,
          error: e.message,
          row_data: sanitize_row(row)
        )
      end
    end

    duration = Time.now - @start_time
    log_info("import_job_completed",
      file_path: file_path,
      total_rows: data.count,
      success_count: success_count,
      error_count: error_count,
      duration_seconds: duration.to_f
    )
  end

  private

  def log_info(event, context = {})
    Rails.logger.info(context.merge(
      job: "ProcessImportJob",
      job_id: @job_id,
      event: event
    ))
  end

  def log_debug(event, context = {})
    Rails.logger.debug(context.merge(
      job: "ProcessImportJob",
      job_id: @job_id,
      event: event
    ))
  end

  def log_warn(event, context = {})
    Rails.logger.warn(context.merge(
      job: "ProcessImportJob",
      job_id: @job_id,
      event: event
    ))
  end

  def sanitize_row(row)
    row.to_h.slice(:sku, :name).merge(has_price: !!row[:price])
  end
end
```

---

## Payment Processing

```go
package payment

import (
    "time"
    "github.com/sirupsen/logrus"
)

var logger = logrus.New()

func ProcessPayment(order Order) error {
    requestID := generateRequestID()
    startTime := time.Now()

    logger.WithFields(logrus.Fields{
        "event":      "payment_started",
        "request_id": requestID,
        "order_id":   order.ID,
        "amount":     order.Total,
        "currency":   order.Currency,
    }).Info()

    // Validate payment method
    if err := validatePaymentMethod(order.PaymentMethod); err != nil {
        logger.WithFields(logrus.Fields{
            "event":       "validation_failed",
            "request_id":  requestID,
            "order_id":    order.ID,
            "error":       err.Error(),
            "payment_method_type": order.PaymentMethod.Type,
        }).Warn()
        return err
    }

    // Process with gateway
    transaction, err := gateway.Charge(order.PaymentMethod, order.Total)
    if err != nil {
        logger.WithFields(logrus.Fields{
            "event":      "payment_gateway_error",
            "request_id": requestID,
            "order_id":   order.ID,
            "gateway":    "stripe",
            "error_code": err.Code,
            "error":      err.Error(),
        }).Error()
        return err
    }

    duration := time.Since(startTime).Milliseconds()

    logger.WithFields(logrus.Fields{
        "event":           "payment_completed",
        "request_id":      requestID,
        "order_id":        order.ID,
        "transaction_id":  transaction.ID,
        "amount":          order.Total,
        "duration_ms":     duration,
    }).Info()

    return nil
}
```

---

## Authentication Flow

```python
import structlog
import time

logger = structlog.get_logger()

def authenticate_user(email: str, password: str, ip_address: str) -> Optional[User]:
    request_id = generate_request_id()
    start_time = time.time()

    logger.info(
        "authentication_attempt",
        request_id=request_id,
        email=email,
        ip_address=ip_address
    )

    # Rate limiting check
    if is_rate_limited(ip_address):
        logger.warning(
            "authentication_rate_limited",
            request_id=request_id,
            email=email,
            ip_address=ip_address
        )
        raise RateLimitError("Too many attempts")

    # Find user
    user = db.users.find_one({"email": email})
    if not user:
        logger.warning(
            "authentication_failed_user_not_found",
            request_id=request_id,
            email=email,
            ip_address=ip_address,
            reason="user_not_found"
        )
        # Still check password to prevent timing attacks
        bcrypt.hashpw("", bcrypt.gensalt())
        raise InvalidCredentialsError()

    # Verify password
    if not bcrypt.checkpw(password.encode(), user["password_hash"]):
        logger.warning(
            "authentication_failed_invalid_password",
            request_id=request_id,
            user_id=user["id"],
            email=email,
            ip_address=ip_address,
            reason="invalid_password"
        )
        # Increment failed attempts counter
        increment_failed_attempts(user["id"])
        raise InvalidCredentialsError()

    # Check if account is locked
    if user.get("locked_until") and user["locked_until"] > time.time():
        logger.warning(
            "authentication_failed_account_locked",
            request_id=request_id,
            user_id=user["id"],
            email=email,
            ip_address=ip_address,
            reason="account_locked",
            locked_until=user["locked_until"]
        )
        raise AccountLockedError()

    # Reset failed attempts on successful login
    reset_failed_attempts(user["id"])

    duration_ms = (time.time() - start_time) * 1000

    logger.info(
        "authentication_success",
        request_id=request_id,
        user_id=user["id"],
        email=email,
        ip_address=ip_address,
        duration_ms=round(duration_ms, 2)
    )

    return User.from_dict(user)
```

---

## Error Handling

```javascript
class ApiService {
  constructor(logger) {
    this.logger = logger;
    this.client = axios.create({
      baseURL: process.env.API_URL,
      timeout: 5000
    });

    this.setupInterceptors();
  }

  setupInterceptors() {
    // Request interceptor
    this.client.interceptors.request.use((config) => {
      config.metadata = { startTime: Date.now() };

      this.logger.debug('api_request_started', {
        method: config.method.toUpperCase(),
        url: config.url,
        request_id: config.headers['X-Request-ID']
      });

      return config;
    });

    // Response interceptor
    this.client.interceptors.response.use(
      (response) => {
        const duration = Date.now() - response.config.metadata.startTime;

        this.logger.info('api_request_success', {
          method: response.config.method.toUpperCase(),
          url: response.config.url,
          status: response.status,
          duration_ms: duration,
          request_id: response.config.headers['X-Request-ID']
        });

        return response;
      },
      (error) => {
        const duration = Date.now() - (error.config?.metadata?.startTime || Date.now());

        if (error.response) {
          // Server responded with error status
          this.logger.error('api_request_error', {
            method: error.config.method.toUpperCase(),
            url: error.config.url,
            status: error.response.status,
            status_text: error.response.statusText,
            duration_ms: duration,
            request_id: error.config.headers['X-Request-ID'],
            error_data: this.sanitizeErrorData(error.response.data)
          });
        } else if (error.request) {
          // Request made but no response
          this.logger.error('api_request_no_response', {
            method: error.config?.method?.toUpperCase(),
            url: error.config?.url,
            duration_ms: duration,
            request_id: error.config?.headers['X-Request-ID'],
            error_code: error.code,
            error_message: error.message
          });
        } else {
          // Request setup error
          this.logger.error('api_request_setup_error', {
            error_message: error.message
          });
        }

        return Promise.reject(error);
      }
    );
  }

  sanitizeErrorData(data) {
    // Remove sensitive data from error logs
    const sanitized = { ...data };
    delete sanitized.password;
    delete sanitized.token;
    delete sanitized.api_key;
    return sanitized;
  }
}
```

---

## Performance Monitoring

```rust
use tracing::{info, info_span, instrument};
use tracing_subscriber;

#[instrument(skip(connection))]
async fn process_batch(
    batch_id: &str,
    items: Vec<Item>,
    connection: &DbConnection,
) -> Result<Vec<ProcessedItem>, Error> {
    let _span = info_span!("process_batch", batch_id = %batch_id, item_count = items.len()).entered();

    info!("batch_processing_started");

    let mut results = Vec::new();
    let mut success_count = 0;
    let mut error_count = 0;

    for (index, item) in items.iter().enumerate() {
        let item_span = info_span!("process_item", index = index, item_id = %item.id).entered();

        match process_item(item, connection).await {
            Ok(processed) => {
                success_count += 1;
                info!(
                    item_id = %item.id,
                    processing_time_ms = processed.processing_time_ms,
                    "item_processed"
                );
                results.push(processed);
            }
            Err(e) => {
                error_count += 1;
                tracing::error!(
                    error = %e,
                    error_type = %e.error_type(),
                    item_id = %item.id,
                    "item_processing_failed"
                );
            }
        }

        drop(item_span);
    }

    info!(
        success_count,
        error_count,
        total = results.len(),
        "batch_processing_completed"
    );

    Ok(results)
}

// Initialize tracing
fn init_tracing() {
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::INFO)
        .with_target(false)
        .init();
}
```

**Expected log output:**
```
batch_processing_started batch_id=batch-123 item_count=100
item_processed item_id=item-1 processing_time_ms=45
item_processed item_id=item-2 processing_time_ms=52
item_processing_failed item_id=item-3 error=connection_timeout error_type=DbError
batch_processing_completed success=98 error=2 total=98
```
