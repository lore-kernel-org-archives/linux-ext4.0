From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 23/54] libext2fs: Support readonly filesystem images
Date: Thu, 19 Mar 2015 14:32:37 -0700
Message-ID: <20150319213237.GH11031@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073803.13308.37011.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32740 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbCSVcn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2015 17:32:43 -0400
Content-Disposition: inline
In-Reply-To: <20150127073803.13308.37011.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Finish adding the new rocompat feature, "readonly", which marks a
filesystem image read-only.  This also fixes a bug in Ted's patch to
add the feature flag; RO_COMPAT_READONLY needs to be kept out of the
RO_COMPAT supported feature list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c           |    7 +++++-
 lib/blkid/probe.h       |    1 +
 lib/ext2fs/ext2fs.h     |   13 ++++++++---
 misc/tune2fs.c          |    2 +-
 resize/main.c           |    8 ++++++
 tests/t_readonly/script |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 83 insertions(+), 6 deletions(-)
 create mode 100644 tests/t_readonly/script

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index e629136..bddb4fa 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1280,7 +1280,8 @@ restart:
 		if ((ctx->mount_flags & EXT2_MF_READONLY) &&
 		    (ctx->options & E2F_OPT_FORCE))
 			flags &= ~EXT2_FLAG_EXCLUSIVE;
-	}
+	} else
+		flags |= EXT2_FLAG_SOFTSUPP_FEATURES;
 
 	ctx->openfs_flags = flags;
 	retval = try_open_fs(ctx, flags, io_ptr, &fs);
@@ -1539,7 +1540,11 @@ failure:
 	features[1] = sb->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP;
 	features[2] = (sb->s_feature_ro_compat &
 		       ~EXT2_LIB_FEATURE_RO_COMPAT_SUPP);
+	if (ctx->options & E2F_OPT_READONLY)
+		features[2] &= ~EXT4_FEATURE_RO_COMPAT_READONLY;
 print_unsupp_features:
+	if (features[2] & EXT4_FEATURE_RO_COMPAT_READONLY)
+		fatal_error(ctx, _("This is a read-only filesystem."));
 	if (features[0] || features[1] || features[2]) {
 		int	i, j;
 		__u32	*mask = features, m;
diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index d6809e1..c578b87 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -111,6 +111,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+#define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
 
 /* for s_feature_incompat */
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d75dd76..cce2d99 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -609,15 +609,22 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
 					 EXT4_LIB_RO_COMPAT_QUOTA|\
-					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_READONLY)
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+/*
+ * N.B. Do not put EXT4_FEATURE_RO_COMPAT_READONLY in this list; that's how
+ * the readonly feature works!
+ */
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
  * to ext2fs_openfs()
+ *
+ * Note that the READONLY feature is integral to debugfs and friends being
+ * able to write to the FS.
  */
 #define EXT2_LIB_SOFTSUPP_INCOMPAT	(0)
-#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_REPLICA)
+#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_REPLICA | \
+					 EXT4_FEATURE_RO_COMPAT_READONLY)
 
 
 /* Translate a block number to a cluster number */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 550932d..66b2ba3 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2675,7 +2675,7 @@ retry_open:
 	open_flag |= EXT2_FLAG_64BITS | EXT2_FLAG_JOURNAL_DEV_OK;
 
 	/* keep the filesystem struct around to dump MMP data */
-	open_flag |= EXT2_FLAG_NOFREE_ON_ERROR;
+	open_flag |= EXT2_FLAG_NOFREE_ON_ERROR | EXT2_FLAG_SOFTSUPP_FEATURES;
 
 	retval = ext2fs_open2(device_name, io_options, open_flag,
 			      0, 0, io_ptr, &fs);
diff --git a/resize/main.c b/resize/main.c
index c25de61..5c4aa9f 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -318,9 +318,15 @@ int main (int argc, char ** argv)
 		io_flags = EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE;
 
 	io_flags |= EXT2_FLAG_64BITS;
-
+	io_flags |= EXT2_FLAG_NOFREE_ON_ERROR;
 	retval = ext2fs_open2(device_name, io_options, io_flags,
 			      0, 0, io_ptr, &fs);
+	if (retval == EXT2_ET_RO_UNSUPP_FEATURE &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_READONLY)) {
+		printf("%s", _("This is a read-only filesystem.\n"));
+		exit(1);
+	}
 	if (retval) {
 		com_err(program_name, retval, _("while trying to open %s"),
 			device_name);
diff --git a/tests/t_readonly/script b/tests/t_readonly/script
new file mode 100644
index 0000000..07bc548
--- /dev/null
+++ b/tests/t_readonly/script
@@ -0,0 +1,58 @@
+test_description="read-only image test"
+if test -x $RESIZE2FS_EXE; then
+
+OUT=$test_name.log
+
+echo read-only image > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 >> $OUT
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 -z $TDB_FILE.0 $TMPFILE 256 >> $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE 256 >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+
+echo enable read-only mode >> $OUT
+$TUNE2FS -O read-only $TMPFILE >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs -O read-only $crc2 >> $OUT
+
+echo using resize2fs to test read-only >> $OUT
+$RESIZE2FS -s $TMPFILE >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after resize2fs $crc3 >> $OUT
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -D $TMPFILE >> $OUT 2>&1
+crc4=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc4 >> $OUT
+
+echo disable read-only mode >> $OUT
+$TUNE2FS -O ^read-only $TMPFILE >> $OUT 2>&1
+crc5=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs -O ^read-only $crc5 >> $OUT
+
+echo using resize2fs to test e2undo >> $OUT
+$RESIZE2FS -s $TMPFILE >> $OUT 2>&1
+crc6=`$CRCSUM $TMPFILE`
+echo $CRCSUM after resize2fs $crc6 >> $OUT
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -D $TMPFILE >> $OUT 2>&1
+crc7=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc7 >> $OUT
+
+echo $crc0 $crc1 $crc2 $crc3 $crc4 $crc5 $crc6 $crc7 >> $OUT
+
+
+if [ $crc0 != $crc1 ] && [ $crc1 != $crc2 ] && [ $crc2 = $crc3 ] && [ $crc2 = $crc4 ] && [ $crc6 != $crc5 ] && [ $crc7 != $crc6 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TMPFILE
+fi
