#!/bin/bash

# print each command before executing, for debugging
set -x

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &> /dev/null
}

# Function to check if a package is installed
is_group_installed() {
  pacman -Qg "$1" &> /dev/null
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install=()

  # Inside the loop in install_packages
  for pkg in "${packages[@]}"; do
    echo "--- Checking: $pkg ---"
    if is_installed "$pkg"; then
        echo "$pkg IS installed (is_installed)"
    else
        echo "$pkg IS NOT installed (is_installed)"
    fi
    
    if is_group_installed "$pkg"; then
        echo "$pkg IS an installed group (is_group_installed)"
    else
        echo "$pkg IS NOT an installed group (is_group_installed)"
    fi
    
    if ! is_installed "$pkg" && ! is_group_installed "$pkg"; then
        echo "Adding $pkg to to_install list."
        to_install+=("$pkg")
    else
        echo "$pkg will NOT be added to to_install list."
    fi
  done
  echo "Packages to install: ${to_install[@]}"

  if [ ${#to_install[@]} -ne 0 ]; then
  
    if yay -Ss "${to_install[@]}"; then
        echo "Installing: ${to_install[*]}"
        yay -S --noconfirm "${to_install[@]}"
        # TODO: check if the package is installed after installation

        echo "Successfully installed/updated: ${to_install[*]}"
    elif pacman -Ss "${to_install[@]}"; then
        echo "Installing: ${to_install[*]}"
        pacman -S --noconfirm "${to_install[@]}"
        # TODO: check if the package is installed after installation

        echo "Successfully installed/updated: ${to_install[*]}"
    else
        echo "ERROR: installation failed for: ${to_install[*]}" >&2
    fi

    # if yay -S --noconfirm "${to_install[@]}"; then
    #   echo "Successfully installed/updated: ${to_install[*]}"
    # else
    #   echo "ERROR: yay command failed for: ${to_install[*]}" >&2
    #   # Optionally, exit with an error code: exit 1
    # fi
  else
    echo "No new packages to install." # Added for clarity
  fi

#   for pkg in "${packages[@]}"; do
#     if ! is_installed "$pkg" && ! is_group_installed "$pkg"; then
#       to_install+=("$pkg")
#     fi
#   done

#   if [ ${#to_install[@]} -ne 0 ]; then
#     echo "Installing: ${to_install[*]}"
#     yay -S --noconfirm "${to_install[@]}"
#   fi
} 