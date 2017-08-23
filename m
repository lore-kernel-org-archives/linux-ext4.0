From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] tune2fs: explain why an fsck is needed
Date: Wed, 23 Aug 2017 11:42:09 -0400
Message-ID: <20170823154210.8756-4-tytso@mit.edu>
References: <20170823154210.8756-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45866 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754136AbdHWPmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Aug 2017 11:42:18 -0400
In-Reply-To: <20170823154210.8756-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently tune2fs just says without any explanation, "run fsck -f".
Add a short explanation that a freshly checked file system is required
to reduce user confusion.  (We could add even more details, but
hopefully this is enough.)

Addresses-Debian-Bug: #857336

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/tune2fs.c                     | 8 ++++++--
 tests/t_dangerous/expect           | 4 ++++
 tests/t_enable_mcsum/expect        | 2 ++
 tests/t_enable_mcsum_initbg/expect | 2 ++
 tests/t_iexpand_mcsum/expect       | 2 ++
 5 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 99c17cc47..3e7ca23e1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -116,6 +116,8 @@ struct blk_move {
 
 errcode_t ext2fs_run_ext3_journal(ext2_filsys *fs);
 
+static const char *fsck_explain = N_("\nThis operation requires a freshly checked filesystem.\n");
+
 static const char *please_fsck = N_("Please run e2fsck -f on the filesystem.\n");
 static const char *please_dir_fsck =
 		N_("Please run e2fsck -fD on the filesystem.\n");
@@ -419,7 +421,8 @@ static void check_fsck_needed(ext2_filsys fs, const char *prompt)
 	if (!(fs->super->s_state & EXT2_VALID_FS) ||
 	    (fs->super->s_state & EXT2_ERROR_FS) ||
 	    (fs->super->s_lastcheck < fs->super->s_mtime)) {
-		printf("\n%s\n", _(please_fsck));
+		puts(_(fsck_explain));
+		puts(_(please_fsck));
 		if (mount_flags & EXT2_MF_READONLY)
 			printf("%s", _("(and reboot afterwards!)\n"));
 		exit(1);
@@ -441,7 +444,8 @@ static void request_dir_fsck_afterwards(ext2_filsys fs)
 		return;
 	fsck_requested++;
 	fs->super->s_state &= ~EXT2_VALID_FS;
-	printf("\n%s\n", _(please_dir_fsck));
+	puts(_(fsck_explain));
+	puts(_(please_dir_fsck));
 	if (mount_flags & EXT2_MF_READONLY)
 		printf("%s", _("(and reboot afterwards!)\n"));
 }
diff --git a/tests/t_dangerous/expect b/tests/t_dangerous/expect
index bae7e0e6e..3bae8fafd 100644
--- a/tests/t_dangerous/expect
+++ b/tests/t_dangerous/expect
@@ -11,6 +11,8 @@ Writing superblocks and filesystem accounting information:      done
 
 tune2fs -O metadata_csum test.img
 
+This operation requires a freshly checked filesystem.
+
 Please run e2fsck -f on the filesystem.
 
 Exit status is 1
@@ -57,6 +59,8 @@ Exit status is 0
 tune2fs -O metadata_csum test.img
 Enabling checksums could take some time.
 Proceed anyway (or wait 5 seconds) ? (y,N) 
+This operation requires a freshly checked filesystem.
+
 Please run e2fsck -fD on the filesystem.
 
 Exit status is 0
diff --git a/tests/t_enable_mcsum/expect b/tests/t_enable_mcsum/expect
index 5a1a33a50..c8a2674bf 100644
--- a/tests/t_enable_mcsum/expect
+++ b/tests/t_enable_mcsum/expect
@@ -18,6 +18,8 @@ Pass 5: Checking group summary information
 Exit status is 0
 tune2fs -O metadata_csum test.img
 
+This operation requires a freshly checked filesystem.
+
 Please run e2fsck -fD on the filesystem.
 
 Exit status is 0
diff --git a/tests/t_enable_mcsum_initbg/expect b/tests/t_enable_mcsum_initbg/expect
index ed4774c2d..e05dd6031 100644
--- a/tests/t_enable_mcsum_initbg/expect
+++ b/tests/t_enable_mcsum_initbg/expect
@@ -18,6 +18,8 @@ Pass 5: Checking group summary information
 Exit status is 0
 tune2fs -O metadata_csum test.img
 
+This operation requires a freshly checked filesystem.
+
 Please run e2fsck -fD on the filesystem.
 
 Exit status is 0
diff --git a/tests/t_iexpand_mcsum/expect b/tests/t_iexpand_mcsum/expect
index 0ebf1626d..772bd6238 100644
--- a/tests/t_iexpand_mcsum/expect
+++ b/tests/t_iexpand_mcsum/expect
@@ -19,6 +19,8 @@ Exit status is 0
 tune2fs -I 256 -O metadata_csum test.img
 Setting inode size 256
 
+This operation requires a freshly checked filesystem.
+
 Please run e2fsck -fD on the filesystem.
 
 Exit status is 0
-- 
2.11.0.rc0.7.gbe5a750
