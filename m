From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] xfstests-bld: populate keyring with default key for test_dummy_encryption
Date: Mon, 12 Dec 2016 22:54:47 -0800
Message-ID: <1481612087-65325-1-git-send-email-ebiggers3@gmail.com>
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: "Theodore Y . Ts'o" <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

We can improve test coverage and simplify the test_dummy_encryption
kernel logic by requiring userspace to add a default master key to the
keyring.  Update xfstests-bld to do this.  This allows xfstests-bld to
test kernels with the corresponding kernel patch applied ("fscrypt /
ext4: make test_dummy_encryption require a keyring key").  It can still
test older kernels too; the key just doesn't get used in that case.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 kvm-xfstests/test-appliance/files/root/fs/ext4/config | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/config b/kvm-xfstests/test-appliance/files/root/fs/ext4/config
index 66d2633..1ae017d 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/config
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/config
@@ -36,6 +36,18 @@ function setup_mount_opts()
     if test -n "$MNTOPTS" ; then
 	EXT_MOUNT_OPTIONS="$EXT_MOUNT_OPTIONS,$MNTOPTS"
     fi
+    if echo "$EXT_MOUNT_OPTIONS" | grep -q test_dummy_encryption; then
+	# Create a new session keyring and add a default master key to it.
+	local raw=""
+	for ((i = 0; i < 64; i++)); do
+	    raw="${raw}\\x$(printf "%02x" $(( $RANDOM % 256 )))"
+	done
+	local mode='\x00\x00\x00\x00'
+	local size='\x40\x00\x00\x00' # assuming little endian
+	keyctl new_session > /dev/null
+	echo -n -e "${mode}${raw}${size}" | \
+		keyctl padd logon fscrypt:4242424242424242 @s > /dev/null
+    fi
 }
 
 function get_mkfs_opts()
-- 
2.8.0.rc3.226.g39d4020
