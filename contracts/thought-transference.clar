;; Thought Transference Contract

(define-map thought-transfers
  { transfer-id: uint }
  {
    source-mind-id: uint,
    target-substrate: (string-ascii 64),
    transfer-status: (string-ascii 20),
    completion-timestamp: (optional uint)
  }
)

(define-data-var next-transfer-id uint u0)

(define-public (initiate-transfer (source-mind-id uint) (target-substrate (string-ascii 64)))
  (let
    ((new-id (+ (var-get next-transfer-id) u1)))
    (var-set next-transfer-id new-id)
    (ok (map-set thought-transfers
      { transfer-id: new-id }
      {
        source-mind-id: source-mind-id,
        target-substrate: target-substrate,
        transfer-status: "initiated",
        completion-timestamp: none
      }
    ))
  )
)

(define-public (complete-transfer (transfer-id uint))
  (let
    ((transfer (unwrap! (map-get? thought-transfers { transfer-id: transfer-id }) (err u404))))
    (ok (map-set thought-transfers
      { transfer-id: transfer-id }
      (merge transfer {
        transfer-status: "completed",
        completion-timestamp: (some block-height)
      })
    ))
  )
)

(define-read-only (get-transfer-status (transfer-id uint))
  (map-get? thought-transfers { transfer-id: transfer-id })
)

