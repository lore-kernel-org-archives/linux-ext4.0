From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: define MKFS_EXT4_PROG and use it instead of "mkfs.ext4" / "mkfs -t ext4"
Date: Sun,  7 Sep 2014 22:06:07 -0400
Message-ID: <1410141968-17551-1-git-send-email-tytso@mit.edu>
References: <20140907192110.GC1066@thunk.org>
Cc: hch@infradead.org, linux-ext4@vger.kernel.org,
	wangxg.fnst@cn.fujitsu.com, eguan@redhat.com,
	Theodore Ts'o <tytso@mit.edu>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42838 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaIHCGV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Sep 2014 22:06:21 -0400
In-Reply-To: <20140907192110.GC1066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 common/config   | 1 +
 common/rc       | 7 +++++--
 tests/btrfs/012 | 1 -
 tests/ext4/003  | 2 +-
 tests/ext4/306  | 2 +-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/common/config b/common/config
index 10cc6fe..f038813 100644
--- a/common/config
+++ b/common/config
@@ -209,6 +209,7 @@ case "$HOSTOS" in
         ;;
     Linux)
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
+        export MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
         export MKFS_UDF_PROG="`set_prog_path mkudffs`"
         export MKFS_BTRFS_PROG="`set_btrfs_mkfs_prog_path_with_opts`"
         export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
diff --git a/common/rc b/common/rc
index 16da898..285bd7c 100644
--- a/common/rc
+++ b/common/rc
@@ -105,6 +105,9 @@ case "$FSTYP" in
     btrfs)
 	 [ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
 	 ;;
+    ext4)
+	 [ "$MKFS_EXT4_PROG" = "" ] && _fatal "mkfs.ext4 not found"
+	 ;;
     nfs)
 	 ;;
 esac
@@ -451,7 +454,7 @@ _scratch_mkfs_ext4()
 
 	local tmp_dir=/tmp/
 
-	/sbin/mkfs -t ext4 -- -F $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV \
+	$MKFS_EXT4_PROG -F $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV \
 			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
 	local mkfs_status=$?
 
@@ -466,7 +469,7 @@ _scratch_mkfs_ext4()
 		) >> $seqres.full
 
 		# running mkfs again. overwrite previous mkfs output files
-		/sbin/mkfs -t ext4 -- -F $extra_mkfs_options $SCRATCH_DEV \
+		$MKFS_EXT4_PROG -F $extra_mkfs_options $SCRATCH_DEV \
 				2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
 		local mkfs_status=$?
 	fi
diff --git a/tests/btrfs/012 b/tests/btrfs/012
index f7e5da5..124c8ae 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -55,7 +55,6 @@ _supported_os Linux
 _require_scratch
 
 BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
-MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
 E2FSCK_PROG="`set_prog_path e2fsck`"
 
 _require_command $BTRFS_CONVERT_PROG btrfs-convert
diff --git a/tests/ext4/003 b/tests/ext4/003
index a2e9d75..53875a9 100755
--- a/tests/ext4/003
+++ b/tests/ext4/003
@@ -43,7 +43,7 @@ _require_ext4_bigalloc
 
 rm -f $seqres.full
 
-mkfs.ext4 -F -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
+$MKFS_EXT4_PROG -F -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
 	>> $seqres.full 2>&1
 _scratch_mount || _fail "couldn't mount fs"
 
diff --git a/tests/ext4/306 b/tests/ext4/306
index fd5c3a2..edc0204 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -48,7 +48,7 @@ _require_scratch
 rm -f $seqres.full
 
 # Make a small ext4 fs with extents disabled & mount it
-mkfs.ext4 -F -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
+$MKFS_EXT4_PROG -F -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
 _scratch_mount || _fail "couldn't mount fs"
 
 # Create a small non-extent-based file
-- 
2.1.0

