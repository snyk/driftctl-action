#!/bin/sh

log_error() {
  echo $1
  exit 1
}

install_driftctl() {
  echo "Installing dctlenv"
  git clone --depth 1 --branch v0.1.6 https://github.com/wbeuil/dctlenv ~/.dctlenv
  export PATH="$HOME/.dctlenv/bin:$PATH"
  gpg --keyserver hkps://keys.openpgp.org --recv-keys 0xACC776A79C824EBD

  echo "Downloading driftctl:$version"
  DCTLENV_PGP=1 DCTLENV_CURL=1 dctlenv use $version
}

parse_inputs() {
  # Required inputs
  if [ "$INPUT_VERSION" != "" ]; then
    version=$INPUT_VERSION
  else
    log_error "Input version cannot be empty"
  fi
}

quiet_flag() {
  case "${version/v/}" in
    "0.1.0"|"0.1.1"|"0.2.0"|"0.2.1"|"0.2.2"|"0.2.3"|"0.3.0"|"0.3.1"|"0.4.0"|"0.5.0"|"0.6.0")
      ;;
    *)
      qflag="--quiet"
      ;;
  esac
}

# First we need to parse inputs
parse_inputs

# Then we install the requested driftctl binary
install_driftctl

# We check if the version of driftctl needs the quiet flag
qflag=""
quiet_flag

# Finally we run the scan command
driftctl scan $qflag