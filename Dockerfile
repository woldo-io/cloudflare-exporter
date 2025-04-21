FROM golang:1.24@sha256:52ff1b35ff8de185bf9fd26c70077190cd0bed1e9f16a2d498ce907e5c421268 AS builder

WORKDIR /app

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY *.go ./

RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build -o /app/cloudflare_exporter

FROM gcr.io/distroless/static-debian12:nonroot@sha256:c0f429e16b13e583da7e5a6ec20dd656d325d88e6819cafe0adb0828976529dc AS final

COPY --from=builder /app/cloudflare_exporter cloudflare_exporter

USER nonroot:nonroot

ENTRYPOINT ["./cloudflare_exporter"]
