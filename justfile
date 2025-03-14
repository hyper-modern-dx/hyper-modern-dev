# Justfile for hyper-modern-nix toolchain tests

# Default recipe to run when just is called without arguments
default:
    @just --list

# Test the toolchain module
test:
    @echo "Testing toolchain module..."
    @echo "Contents of default.nix:"
    cat modules/toolchain/default.nix
    @echo ""
    @echo "Checking Nix syntax..."
    nix-instantiate --parse modules/toolchain/default.nix
    @echo ""
    @echo "If the module has a valid flake.homeManagerModules.toolchain attribute, it should work when included in a flake!"
    @echo "Test complete! ✓"

# Test for the user-specific toolchain instantiation
test-user:
    @echo "Testing toolchain module with user parameters..."
    @chmod +x ./test-toolchain.sh
    ./test-toolchain.sh

# Clean up test artifacts
clean:
    rm -f ~/.toolchain-test
    rm -rf .test-toolchain