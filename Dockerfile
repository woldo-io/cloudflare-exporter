FROM golang:1.25@sha256:5502b0e56fca23feba76dbc5387ba59c593c02ccc2f0f7355871ea9a0852cebe AS builder

WORKDIR /app

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY *.go ./

RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build -o /app/cloudflare_exporter

FROM gcr.io/distroless/static-debian12:nonroot@sha256:b35229a3a6398fe8f86138c74c611e386f128c20378354fc5442811700d5600d AS final

COPY --from=builder /app/cloudflare_exporter cloudflare_exporter

USER nonroot:nonroot

ENTRYPOINT ["./cloudflare_exporter"]
