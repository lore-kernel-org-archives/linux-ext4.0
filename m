From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/9] tests: check proper operation of metadata_csum_seed
Date: Sat, 13 Feb 2016 14:37:57 -0800 (PST)
Message-ID: <20160213223757.25381.15201.stgit@birch.djwong.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36133 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbcBMWiD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Feb 2016 17:38:03 -0500
In-Reply-To: <20160213223725.25381.20929.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ismounted.c                           |   14 ++++++
 tests/t_change_uuid/expect                       |    7 +++
 tests/t_change_uuid/script                       |   34 ++++++++++++++
 tests/t_change_uuid_mcsum/expect                 |    7 +++
 tests/t_change_uuid_mcsum/script                 |   34 ++++++++++++++
 tests/t_change_uuid_mcsum_mounted/expect         |    7 +++
 tests/t_change_uuid_mcsum_mounted/script         |   34 ++++++++++++++
 tests/t_change_uuid_mcsum_seed_mounted/expect    |   21 +++++++++
 tests/t_change_uuid_mcsum_seed_mounted/script    |   52 ++++++++++++++++++++++
 tests/t_change_uuid_mounted/expect               |    7 +++
 tests/t_change_uuid_mounted/script               |   34 ++++++++++++++
 tests/t_disable_changed_csum_seed/expect         |   17 +++++++
 tests/t_disable_changed_csum_seed/script         |   47 ++++++++++++++++++++
 tests/t_disable_changed_csum_seed_mounted/expect |   19 ++++++++
 tests/t_disable_changed_csum_seed_mounted/script |   47 ++++++++++++++++++++
 tests/t_disable_csum_seed/expect                 |   14 ++++++
 tests/t_disable_csum_seed/script                 |   43 ++++++++++++++++++
 tests/t_disable_meta_csum_and_seed/expect        |   14 ++++++
 tests/t_disable_meta_csum_and_seed/script        |   44 +++++++++++++++++++
 tests/t_enable_csum_seed/expect                  |   12 +++++
 tests/t_enable_csum_seed/script                  |   38 ++++++++++++++++
 tests/t_format_csum_seed/expect                  |   10 ++++
 tests/t_format_csum_seed/script                  |   34 ++++++++++++++
 23 files changed, 590 insertions(+)
 create mode 100644 tests/t_change_uuid/expect
 create mode 100755 tests/t_change_uuid/script
 create mode 100644 tests/t_change_uuid_mcsum/expect
 create mode 100755 tests/t_change_uuid_mcsum/script
 create mode 100644 tests/t_change_uuid_mcsum_mounted/expect
 create mode 100755 tests/t_change_uuid_mcsum_mounted/script
 create mode 100644 tests/t_change_uuid_mcsum_seed_mounted/expect
 create mode 100755 tests/t_change_uuid_mcsum_seed_mounted/script
 create mode 100644 tests/t_change_uuid_mounted/expect
 create mode 100755 tests/t_change_uuid_mounted/script
 create mode 100644 tests/t_disable_changed_csum_seed/expect
 create mode 100755 tests/t_disable_changed_csum_seed/script
 create mode 100644 tests/t_disable_changed_csum_seed_mounted/expect
 create mode 100755 tests/t_disable_changed_csum_seed_mounted/script
 create mode 100644 tests/t_disable_csum_seed/expect
 create mode 100755 tests/t_disable_csum_seed/script
 create mode 100644 tests/t_disable_meta_csum_and_seed/expect
 create mode 100755 tests/t_disable_meta_csum_and_seed/script
 create mode 100644 tests/t_enable_csum_seed/expect
 create mode 100755 tests/t_enable_csum_seed/script
 create mode 100644 tests/t_format_csum_seed/expect
 create mode 100755 tests/t_format_csum_seed/script


diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
index b1eff85..ae2e832 100644
--- a/lib/ext2fs/ismounted.c
+++ b/lib/ext2fs/ismounted.c
@@ -90,6 +90,20 @@ static errcode_t check_mntent_file(const char *mtab_file, const char *file,
 	int		fd;
 
 	*mount_flags = 0;
+
+	if (getenv("EXT2FS_PRETEND_RO_MOUNT")) {
+		*mount_flags = EXT2_MF_MOUNTED | EXT2_MF_READONLY;
+		if (getenv("EXT2FS_PRETEND_ROOTFS"))
+			*mount_flags = EXT2_MF_ISROOT;
+		return 0;
+	}
+	if (getenv("EXT2FS_PRETEND_RW_MOUNT")) {
+		*mount_flags = EXT2_MF_MOUNTED;
+		if (getenv("EXT2FS_PRETEND_ROOTFS"))
+			*mount_flags = EXT2_MF_ISROOT;
+		return 0;
+	}
+
 	if ((f = setmntent (mtab_file, "r")) == NULL) {
 		if (errno == ENOENT) {
 			if (getenv("EXT2FS_NO_MTAB_OK"))
diff --git a/tests/t_change_uuid/expect b/tests/t_change_uuid/expect
new file mode 100644
index 0000000..0a9b20e
--- /dev/null
+++ b/tests/t_change_uuid/expect
@@ -0,0 +1,7 @@
+create fs without metadata_csum
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+change UUID
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
diff --git a/tests/t_change_uuid/script b/tests/t_change_uuid/script
new file mode 100755
index 0000000..be8cbfa
--- /dev/null
+++ b/tests/t_change_uuid/script
@@ -0,0 +1,34 @@
+test_description="change uuid on a pre-metadata-csum"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs without metadata_csum" >> $OUT
+$MKE2FS -O ^metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+$TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_change_uuid_mcsum/expect b/tests/t_change_uuid_mcsum/expect
new file mode 100644
index 0000000..fb26e72
--- /dev/null
+++ b/tests/t_change_uuid_mcsum/expect
@@ -0,0 +1,7 @@
+create fs with metadata_csum
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+change UUID
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
diff --git a/tests/t_change_uuid_mcsum/script b/tests/t_change_uuid_mcsum/script
new file mode 100755
index 0000000..826d287
--- /dev/null
+++ b/tests/t_change_uuid_mcsum/script
@@ -0,0 +1,34 @@
+test_description="change uuid on a metadata-csum"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs with metadata_csum" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+$TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_change_uuid_mcsum_mounted/expect b/tests/t_change_uuid_mcsum_mounted/expect
new file mode 100644
index 0000000..e10e9a9
--- /dev/null
+++ b/tests/t_change_uuid_mcsum_mounted/expect
@@ -0,0 +1,7 @@
+create fs with metadata_csum
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+change UUID
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+check filesystem
+fsck returns 0
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
diff --git a/tests/t_change_uuid_mcsum_mounted/script b/tests/t_change_uuid_mcsum_mounted/script
new file mode 100755
index 0000000..0efcae5
--- /dev/null
+++ b/tests/t_change_uuid_mcsum_mounted/script
@@ -0,0 +1,34 @@
+test_description="change uuid on a metadata-csum"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs with metadata_csum" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+EXT2FS_PRETEND_RW_MOUNT=1 $TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_change_uuid_mcsum_seed_mounted/expect b/tests/t_change_uuid_mcsum_seed_mounted/expect
new file mode 100644
index 0000000..b2d2d91
--- /dev/null
+++ b/tests/t_change_uuid_mcsum_seed_mounted/expect
@@ -0,0 +1,21 @@
+create fs with metadata_csum
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+change UUID
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+check filesystem
+fsck returns 0
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+turn on csum seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+change UUID
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
diff --git a/tests/t_change_uuid_mcsum_seed_mounted/script b/tests/t_change_uuid_mcsum_seed_mounted/script
new file mode 100755
index 0000000..05b0bd7
--- /dev/null
+++ b/tests/t_change_uuid_mcsum_seed_mounted/script
@@ -0,0 +1,52 @@
+test_description="change uuid on a metadata-csum with mcsum-seed"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs with metadata_csum" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+EXT2FS_PRETEND_RW_MOUNT=1 $TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn on csum seed" >> $OUT
+EXT2FS_PRETEND_RW_MOUNT=1 $TUNE2FS -O metadata_csuM_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+EXT2FS_PRETEND_RW_MOUNT=1 $TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_change_uuid_mounted/expect b/tests/t_change_uuid_mounted/expect
new file mode 100644
index 0000000..0a9b20e
--- /dev/null
+++ b/tests/t_change_uuid_mounted/expect
@@ -0,0 +1,7 @@
+create fs without metadata_csum
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+change UUID
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
diff --git a/tests/t_change_uuid_mounted/script b/tests/t_change_uuid_mounted/script
new file mode 100755
index 0000000..827ff59
--- /dev/null
+++ b/tests/t_change_uuid_mounted/script
@@ -0,0 +1,34 @@
+test_description="change uuid on a mounted pre-metadata-csum"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs without metadata_csum" >> $OUT
+$MKE2FS -O ^metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+EXT2FS_PRETEND_RW_MOUNT=1 $TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_disable_changed_csum_seed/expect b/tests/t_disable_changed_csum_seed/expect
new file mode 100644
index 0000000..e00f367
--- /dev/null
+++ b/tests/t_disable_changed_csum_seed/expect
@@ -0,0 +1,17 @@
+create fs without csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+turn on csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+change UUID
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
+turn off csum_seed
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
diff --git a/tests/t_disable_changed_csum_seed/script b/tests/t_disable_changed_csum_seed/script
new file mode 100755
index 0000000..9443731
--- /dev/null
+++ b/tests/t_disable_changed_csum_seed/script
@@ -0,0 +1,47 @@
+test_description="disable csum seed via tune2fs after changing uuid"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs without csum_seed" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn on csum_seed" >> $OUT
+$TUNE2FS -O metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+$TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn off csum_seed" >> $OUT
+$TUNE2FS -O ^metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_disable_changed_csum_seed_mounted/expect b/tests/t_disable_changed_csum_seed_mounted/expect
new file mode 100644
index 0000000..288494b
--- /dev/null
+++ b/tests/t_disable_changed_csum_seed_mounted/expect
@@ -0,0 +1,19 @@
+create fs without csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+turn on csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+change UUID
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
+turn off csum_seed
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          a61be2e0-b3b8-4fbc-b2cd-d84b306b9731
+Checksum seed:            0x3ba62721
diff --git a/tests/t_disable_changed_csum_seed_mounted/script b/tests/t_disable_changed_csum_seed_mounted/script
new file mode 100755
index 0000000..3be6dd9
--- /dev/null
+++ b/tests/t_disable_changed_csum_seed_mounted/script
@@ -0,0 +1,47 @@
+test_description="disable csum seed on mounted fs via tune2fs after changing uuid"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs without csum_seed" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn on csum_seed" >> $OUT
+$TUNE2FS -O metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change UUID" >> $OUT
+$TUNE2FS -U a61be2e0-b3b8-4fbc-b2cd-d84b306b9731 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn off csum_seed" >> $OUT
+EXT2FS_PRETEND_RW_MOUNT=1 $TUNE2FS -O ^metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_disable_csum_seed/expect b/tests/t_disable_csum_seed/expect
new file mode 100644
index 0000000..e6c50fe
--- /dev/null
+++ b/tests/t_disable_csum_seed/expect
@@ -0,0 +1,14 @@
+create fs without csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+turn on csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+turn off csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+check filesystem
+fsck returns 0
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
diff --git a/tests/t_disable_csum_seed/script b/tests/t_disable_csum_seed/script
new file mode 100755
index 0000000..28fdc5c
--- /dev/null
+++ b/tests/t_disable_csum_seed/script
@@ -0,0 +1,43 @@
+test_description="disable csum seed via tune2fs"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs without csum_seed" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn on csum_seed" >> $OUT
+$TUNE2FS -O metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn off csum_seed" >> $OUT
+$TUNE2FS -O ^metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_disable_meta_csum_and_seed/expect b/tests/t_disable_meta_csum_and_seed/expect
new file mode 100644
index 0000000..a1c9cca
--- /dev/null
+++ b/tests/t_disable_meta_csum_and_seed/expect
@@ -0,0 +1,14 @@
+create fs without csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+turn on csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+turn off metadata_csum
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+check filesystem
+fsck returns 0
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
diff --git a/tests/t_disable_meta_csum_and_seed/script b/tests/t_disable_meta_csum_and_seed/script
new file mode 100755
index 0000000..9eb18e3
--- /dev/null
+++ b/tests/t_disable_meta_csum_and_seed/script
@@ -0,0 +1,44 @@
+test_description="disable csum seed and csums via tune2fs"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs without csum_seed" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn on csum_seed" >> $OUT
+$TUNE2FS -O metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn off metadata_csum" >> $OUT
+$TUNE2FS -O ^metadata_csum $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | grep 'metadata_csum' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_enable_csum_seed/expect b/tests/t_enable_csum_seed/expect
new file mode 100644
index 0000000..07d9a4f
--- /dev/null
+++ b/tests/t_enable_csum_seed/expect
@@ -0,0 +1,12 @@
+create fs without csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+turn on csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+change uuid
+Filesystem UUID:          1dd136c6-e47a-4833-9bf5-519f8aacabe4
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          1dd136c6-e47a-4833-9bf5-519f8aacabe4
+Checksum seed:            0x3ba62721
diff --git a/tests/t_enable_csum_seed/script b/tests/t_enable_csum_seed/script
new file mode 100755
index 0000000..55cade6
--- /dev/null
+++ b/tests/t_enable_csum_seed/script
@@ -0,0 +1,38 @@
+test_description="enable csum seed via tune2fs"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs without csum_seed" >> $OUT
+$MKE2FS -O metadata_csum,^metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "turn on csum_seed" >> $OUT
+$TUNE2FS -O metadata_csum_seed $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change uuid" >> $OUT
+$TUNE2FS -U 1dd136c6-e47a-4833-9bf5-519f8aacabe4 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
diff --git a/tests/t_format_csum_seed/expect b/tests/t_format_csum_seed/expect
new file mode 100644
index 0000000..39e6d6a
--- /dev/null
+++ b/tests/t_format_csum_seed/expect
@@ -0,0 +1,10 @@
+create fs with csum_seed
+Filesystem UUID:          6b33f586-a183-4383-921d-30da3fef2e5c
+Checksum seed:            0x3ba62721
+change uuid
+Filesystem UUID:          1dd136c6-e47a-4833-9bf5-519f8aacabe4
+Checksum seed:            0x3ba62721
+check filesystem
+fsck returns 0
+Filesystem UUID:          1dd136c6-e47a-4833-9bf5-519f8aacabe4
+Checksum seed:            0x3ba62721
diff --git a/tests/t_format_csum_seed/script b/tests/t_format_csum_seed/script
new file mode 100755
index 0000000..1829514
--- /dev/null
+++ b/tests/t_format_csum_seed/script
@@ -0,0 +1,34 @@
+test_description="format with csum_seed"
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+echo "create fs with csum_seed" >> $OUT
+$MKE2FS -O metadata_csum,metadata_csum_seed -U 6b33f586-a183-4383-921d-30da3fef2e5c -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "change uuid" >> $OUT
+$TUNE2FS -U 1dd136c6-e47a-4833-9bf5-519f8aacabe4 $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+echo "check filesystem" >> $OUT
+$FSCK $FSCK_OPT -fy $TMPFILE > /dev/null 2>&1
+echo "fsck returns $?" >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | egrep '(Checksum seed:|UUID)' >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+

