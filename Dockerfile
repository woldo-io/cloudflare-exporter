FROM golang:1.24@sha256:991aa6a6e4431f2f01e869a812934bd60fbc87fb939e4a1ea54b8494ab9d2fc6 AS builder

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
