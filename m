From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 2/4] tune2fs: kill external journal if device not found
Date: Fri, 23 Sep 2011 17:38:42 -0600
Message-ID: <1316821124-7461-2-git-send-email-adilger@whamcloud.com>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48272 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1IWXit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 19:38:49 -0400
In-Reply-To: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Continue to remove the external journal device even if the device
cannot be found.

Add a test to verify that the journal device/UUID are actually removed
from the superblock.  It isn't possible to use a real journal device
for testing without loopback devices and such (it must be a block device)
and this would invite complexity and failures in the regression test.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

#
# total: 0 errors, 0 warnings, 82 lines checked
#
# Your patch has no obvious style problems and is ready for submission.
---
 misc/tune2fs.c            |   18 ++++++++++--------
 tests/u_ext_jnl_rm/script |   28 ++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 8 deletions(-)
 create mode 100644 tests/u_ext_jnl_rm/script

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3e12697..fa9728b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -184,7 +184,7 @@ static void remove_journal_device(ext2_filsys fs)
 		journal_path =
 			ext2fs_find_block_device(fs->super->s_journal_dev);
 		if (!journal_path)
-			return;
+			goto no_valid_journal;
 	}
 
 #ifdef CONFIG_TESTIO_DEBUG
@@ -202,7 +202,8 @@ static void remove_journal_device(ext2_filsys fs)
 			_("while trying to open external journal"));
 		goto no_valid_journal;
 	}
-	if (!(jfs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+	if (!(jfs->super->s_feature_incompat &
+	      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
 		fprintf(stderr, _("%s is not a journal device.\n"),
 			journal_path);
 		goto no_valid_journal;
@@ -216,8 +217,8 @@ static void remove_journal_device(ext2_filsys fs)
 	}
 
 	jsb = (journal_superblock_t *) buf;
-	if ((jsb->s_header.h_magic != (unsigned) ntohl(JFS_MAGIC_NUMBER)) ||
-	    (jsb->s_header.h_blocktype != (unsigned) ntohl(JFS_SUPERBLOCK_V2))) {
+	if ((jsb->s_header.h_magic != (unsigned)ntohl(JFS_MAGIC_NUMBER)) ||
+	    (jsb->s_header.h_blocktype != (unsigned)ntohl(JFS_SUPERBLOCK_V2))) {
 		fputs(_("Journal superblock not found!\n"), stderr);
 		goto no_valid_journal;
 	}
@@ -225,8 +226,7 @@ static void remove_journal_device(ext2_filsys fs)
 	/* Find the filesystem UUID */
 	nr_users = ntohl(jsb->s_nr_users);
 	for (i = 0; i < nr_users; i++) {
-		if (memcmp(fs->super->s_uuid,
-			   &jsb->s_users[i*16], 16) == 0)
+		if (memcmp(fs->super->s_uuid, &jsb->s_users[i * 16], 16) == 0)
 			break;
 	}
 	if (i >= nr_users) {
@@ -237,7 +237,7 @@ static void remove_journal_device(ext2_filsys fs)
 	}
 	nr_users--;
 	for (i = 0; i < nr_users; i++)
-		memcpy(&jsb->s_users[i*16], &jsb->s_users[(i+1)*16], 16);
+		memcpy(&jsb->s_users[i * 16], &jsb->s_users[(i + 1) * 16], 16);
 	jsb->s_nr_users = htonl(nr_users);
 
 	/* Write back the journal superblock */
@@ -251,7 +251,9 @@ static void remove_journal_device(ext2_filsys fs)
 
 no_valid_journal:
 	if (commit_remove_journal == 0) {
-		fputs(_("Journal NOT removed\n"), stderr);
+		fputs(_("Cannot locate journal device. It was NOT removed\n"
+			"Use -f option to remove missing journal device.\n"),
+		      stderr);
 		exit(1);
 	}
 	fs->super->s_journal_dev = 0;
diff --git a/tests/u_ext_jnl_rm/script b/tests/u_ext_jnl_rm/script
new file mode 100644
index 0000000..d7217b6
--- /dev/null
+++ b/tests/u_ext_jnl_rm/script
@@ -0,0 +1,28 @@
+printf "remove missing external journal device: "
+OUT=$test_name.log
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 $TMPFILE >> $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE >> $OUT 2>&1
+
+echo "debugfs add journal device/UUID" >> $OUT
+$DEBUGFS -w -f - $TMPFILE <<- EOF >> $OUT 2>&1
+	feature has_journal
+	ssv journal_dev 0x9999
+	ssv journal_uuid 1db3f677-6832-4adb-bafc-8e4059c30a33
+EOF
+
+echo "tune2fs -f -O ^has_journal $TMPFILE" >> $OUT
+$TUNE2FS -f -O ^has_journal $TMPFILE >> $OUT 2>&1
+$DUMPE2FS -h $TMPFILE >> $OUT 2>&1
+if [ "$(grep 'Journal UUID:' $OUT)" ]; then
+	rm -f $test_name.ok
+	mv $test_name.log $test_name.failed
+	echo "failed"
+else
+	echo "ok"
+	mv $test_name.log $test_name.ok
+	rm -f $test_name.failed
+fi
+rm -f $TMPFILE
-- 
1.7.3.4

