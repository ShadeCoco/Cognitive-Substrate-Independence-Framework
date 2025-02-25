;; Experiential Fidelity Preservation Contract

(define-map fidelity-records
  { record-id: uint }
  {
    mind-id: uint,
    qualia-hash: (buff 32),
    substrate: (string-ascii 64),
    fidelity-score: uint
  }
)

(define-data-var next-record-id uint u0)

(define-public (record-experience (mind-id uint) (qualia-hash (buff 32)) (substrate (string-ascii 64)) (fidelity-score uint))
  (let
    ((new-id (+ (var-get next-record-id) u1)))
    (var-set next-record-id new-id)
    (ok (map-set fidelity-records
      { record-id: new-id }
      {
        mind-id: mind-id,
        qualia-hash: qualia-hash,
        substrate: substrate,
        fidelity-score: fidelity-score
      }
    ))
  )
)

(define-read-only (get-fidelity-record (record-id uint))
  (map-get? fidelity-records { record-id: record-id })
)

(define-read-only (calculate-average-fidelity (mind-id uint))
  (let
    ((records (filter get-records-for-mind (map-to-list fidelity-records))))
    (ok (if (> (len records) u0)
      (/ (fold + (map get-fidelity-score records) u0) (len records))
      u0))
  )
)

(define-private (get-records-for-mind (entry {id: uint, value: {mind-id: uint, qualia-hash: (buff 32), substrate: (string-ascii 64), fidelity-score: uint}}))
  (is-eq (get mind-id (get value entry)) mind-id)
)

(define-private (get-fidelity-score (entry {id: uint, value: {mind-id: uint, qualia-hash: (buff 32), substrate: (string-ascii 64), fidelity-score: uint}}))
  (get fidelity-score (get value entry))
)

