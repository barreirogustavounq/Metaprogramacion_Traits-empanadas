# Template de Proyecto Ruby para Objetos 3 (UNQ)


# Setup

La primera vez que clonen el repositorio deberan instalar las dependencias que ya tenemos definidas en Gemfile (rspec), para esto tienen que tener instalado `ruby` y `bundler`.

Checkear que tengo ruby

```bash
ruby -v
> ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux-gnu]
```

Checkear que tengo Bundler

```bash
bundle --version
> Bundler version 1.17.3
```

Ahora sí, instalamos con

```bash
bundle install
```

# Ejectuar los tests

Desde consola

```bash
bundle exec rspec spec
```

