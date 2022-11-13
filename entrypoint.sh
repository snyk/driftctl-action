#!/bin/sh

log_error() {
  echo $1
  exit 1
}

install_driftctl() {
  echo "Installing dctlenv"
  git clone --depth 1 --branch v0.1.8 https://github.com/wbeuil/dctlenv ~/.dctlenv
  export PATH="$HOME/.dctlenv/bin:$PATH"

  gpg --keyserver hkps://keys.openpgp.org --recv-keys 0xACC776A79C824EBD

  echo "Downloading driftctl:$version"
  DCTLENV_CURL=1 dctlenv use $version
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
  if version_le "${version/v/}" "0.6.0"; then
    return
  fi
  qflag="--quiet"
}

version_le() {
  [ "$1" = "`echo -e "$1\n$2" | sort -V | head -n 1`" ]
}

# First we need to parse inputs
parse_inputs

# Then we install the requested driftctl binary
install_driftctl || log_error "Fail to install driftctl"

# We check if the version of driftctl needs the quiet flag
qflag=""
quiet_flag

# Run scan, store exit code, format output, output scan in runner and return exit code
scan_output(){
  scan_output="$(driftctl scan $qflag $INPUT_ARGS;return)"
  scan_exit=$?
  scan_output="${scan_output//$'\r'/'%0D'}"
  echo -e "$scan_output"
  return $scan_exit
}

# Run scan function and store in variable
scan_output=$(scan_output)

# Store exit code from scan command run in scan function
scan_exit=$?

#Check exit code, echo scan, add delimiter, output to $GITHUB_OUTPUT, and fail job if scan exit code 1 or 2
scan_exit_code(){
  if [ $1 -eq 1 ]; then
    echo -e "$scan_output"
    echo 'SCAN_OUTPUT<<EOF' >> $GITHUB_OUTPUT
    echo -e "$scan_output" >> $GITHUB_OUTPUT
    echo 'EOF' >> $GITHUB_OUTPUT
    exit $1
  elif [ $1 -eq 2 ]; then
    exit 1
  else
    exit $1
  fi
}

# Run exit code function 
scan_exit_code $scan_exit
