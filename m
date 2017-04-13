From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] tune2fs: fix BUGs of tuning project quota
Date: Thu, 13 Apr 2017 22:35:47 +0800
Message-ID: <20170413143547.33438-1-wshilong@ddn.com>
Cc: wshilong@ddn.com, andreas.dilger@intel.com, lixi@ddn.com,
        sihara@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35864 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbdDMOgE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Apr 2017 10:36:04 -0400
Received: by mail-pf0-f193.google.com with SMTP id i5so11126836pfc.3
        for <linux-ext4@vger.kernel.org>; Thu, 13 Apr 2017 07:36:04 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Somehow project quota did not work well for enable/disable,
Add some tests to address it.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 misc/tune2fs.c              | 38 +++++++++++++++++++++++++-------------
 tests/t_project_1on/name    |  1 +
 tests/t_project_1on/script  | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/t_project_2off/name   |  1 +
 tests/t_project_2off/script | 35 +++++++++++++++++++++++++++++++++++
 tests/t_project_3on/name    |  1 +
 tests/t_project_3on/script  | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/t_project_4off/name   |  1 +
 tests/t_project_4off/script | 35 +++++++++++++++++++++++++++++++++++
 9 files changed, 181 insertions(+), 13 deletions(-)
 create mode 100644 tests/t_project_1on/name
 create mode 100644 tests/t_project_1on/script
 create mode 100644 tests/t_project_2off/name
 create mode 100644 tests/t_project_2off/script
 create mode 100644 tests/t_project_3on/name
 create mode 100644 tests/t_project_3on/script
 create mode 100644 tests/t_project_4off/name
 create mode 100644 tests/t_project_4off/script

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index f1bad60..4469067 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -188,6 +188,7 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
+		EXT4_FEATURE_RO_COMPAT_PROJECT |
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
 		EXT4_FEATURE_RO_COMPAT_READONLY
 };
@@ -1309,14 +1310,17 @@ mmp_error:
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
-		if (!Q_flag && !ext2fs_has_feature_quota(sb))
-			fputs(_("\nWarning: enabled project without quota together\n"),
-				stderr);
 		Q_flag = 1;
 		quota_enable[PRJQUOTA] = QOPT_ENABLE;
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
+			EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		Q_flag = 1;
+		quota_enable[PRJQUOTA] = QOPT_DISABLE;
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 		/*
 		 * Set the Q_flag here and handle the quota options in the code
@@ -1484,6 +1488,7 @@ static void handle_quota_options(ext2_filsys fs)
 	ext2_ino_t qf_ino;
 	enum quota_type qtype;
 	unsigned int qtype_bits = 0;
+	int need_dirty = 0;
 
 	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
 		if (quota_enable[qtype] != 0)
@@ -1527,6 +1532,11 @@ static void handle_quota_options(ext2_filsys fs)
 					qtype);
 				exit(1);
 			}
+			/* Enable Quota feature if one of quota enabled */
+			if (!ext2fs_has_feature_quota(fs->super)) {
+				ext2fs_set_feature_quota(fs->super);
+				need_dirty = 1;
+			}
 		} else if (quota_enable[qtype] == QOPT_DISABLE) {
 			retval = quota_remove_inode(fs, qtype);
 			if (retval) {
@@ -1535,25 +1545,27 @@ static void handle_quota_options(ext2_filsys fs)
 					qtype);
 				exit(1);
 			}
+			if (qtype == PRJQUOTA) {
+				ext2fs_clear_feature_project(fs->super);
+				need_dirty = 1;
+			}
 		}
 	}
 
 	quota_release_context(&qctx);
-
-	if (qtype_bits) {
-		ext2fs_set_feature_quota(fs->super);
-		ext2fs_mark_super_dirty(fs);
-	} else {
+	/* Clear Quota feature if all quota types disabled. */
+	if (!qtype_bits) {
 		for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
-			if (*quota_sb_inump(fs->super, qtype) != 0)
+			if (*quota_sb_inump(fs->super, qtype))
 				break;
 		if (qtype == MAXQUOTAS) {
-			fs->super->s_feature_ro_compat &=
-					~EXT4_FEATURE_RO_COMPAT_QUOTA;
-			ext2fs_mark_super_dirty(fs);
+			ext2fs_clear_feature_quota(fs->super);
+			need_dirty = 1;
 		}
-	}
 
+	}
+	if (need_dirty)
+		ext2fs_mark_super_dirty(fs);
 	return;
 }
 
diff --git a/tests/t_project_1on/name b/tests/t_project_1on/name
new file mode 100644
index 0000000..6b2dd29
--- /dev/null
+++ b/tests/t_project_1on/name
@@ -0,0 +1 @@
+enable project using tune2fs -O option
diff --git a/tests/t_project_1on/script b/tests/t_project_1on/script
new file mode 100644
index 0000000..1489ade
--- /dev/null
+++ b/tests/t_project_1on/script
@@ -0,0 +1,41 @@
+FSCK_OPT=-yf
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 4096 $TMPFILE 10000 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+dd if=/dev/zero of=$TMPFILE.2 bs=1048576 count=1 >> $test_name.log 2>&1
+cat <<- EOF | $DEBUGFS -w -f /dev/stdin $TMPFILE >> $test_name.log 2>&1
+	write $TMPFILE.2 file1
+	set_inode_field file1 projid 500
+EOF
+rm -f $TMPFILE.2
+
+$TUNE2FS -O project  $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -O project failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "e2fsck with project enabled failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+rm -f $TMPFILE
diff --git a/tests/t_project_2off/name b/tests/t_project_2off/name
new file mode 100644
index 0000000..293717d
--- /dev/null
+++ b/tests/t_project_2off/name
@@ -0,0 +1 @@
+disable project using tune2fs
diff --git a/tests/t_project_2off/script b/tests/t_project_2off/script
new file mode 100644
index 0000000..7809997
--- /dev/null
+++ b/tests/t_project_2off/script
@@ -0,0 +1,35 @@
+FSCK_OPT=-yf
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 4096 -O quota,project $TMPFILE 100 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs -O quota,project failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$TUNE2FS -O ^project $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -O ^project failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "e2fsck with project enabled failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+rm -f $TMPFILE
diff --git a/tests/t_project_3on/name b/tests/t_project_3on/name
new file mode 100644
index 0000000..9a10680
--- /dev/null
+++ b/tests/t_project_3on/name
@@ -0,0 +1 @@
+enable project using tune2fs -Q option
diff --git a/tests/t_project_3on/script b/tests/t_project_3on/script
new file mode 100644
index 0000000..9666031
--- /dev/null
+++ b/tests/t_project_3on/script
@@ -0,0 +1,41 @@
+FSCK_OPT=-yf
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 4096 $TMPFILE 10000 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+dd if=/dev/zero of=$TMPFILE.2 bs=1048576 count=1 >> $test_name.log 2>&1
+cat <<- EOF | $DEBUGFS -w -f /dev/stdin $TMPFILE >> $test_name.log 2>&1
+	write $TMPFILE.2 file1
+	set_inode_field file1 projid 500
+EOF
+rm -f $TMPFILE.2
+
+$TUNE2FS -Q prj  $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -Q project failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "e2fsck with project enabled failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+rm -f $TMPFILE
diff --git a/tests/t_project_4off/name b/tests/t_project_4off/name
new file mode 100644
index 0000000..5ef6430
--- /dev/null
+++ b/tests/t_project_4off/name
@@ -0,0 +1 @@
+disable project using tune2fs -Q option
diff --git a/tests/t_project_4off/script b/tests/t_project_4off/script
new file mode 100644
index 0000000..332807a
--- /dev/null
+++ b/tests/t_project_4off/script
@@ -0,0 +1,35 @@
+FSCK_OPT=-yf
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 4096 -O quota,project $TMPFILE 100 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs -O quota,project failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$TUNE2FS -Q ^prj $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -O ^project failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "e2fsck with project enabled failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+rm -f $TMPFILE
-- 
2.9.3
