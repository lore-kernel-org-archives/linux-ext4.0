From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] ext4: create nojournal_checksum mount option
Date: Mon, 20 Oct 2014 18:05:07 -0700
Message-ID: <20141021010507.21404.59996.stgit@birch.djwong.org>
References: <20141021010501.21404.59849.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36505 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaJUBFN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2014 21:05:13 -0400
In-Reply-To: <20141021010501.21404.59849.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a mount option to disable journal checksumming (because the
metadata_csum feature turns it on by default now), and fix remount not
to allow changing the journal checksumming option, since changing the
mount options has no effect on the journal.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5d51dbf..bf46927 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1166,7 +1166,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
-	Opt_max_dir_size_kb,
+	Opt_max_dir_size_kb, Opt_nojournal_checksum,
 };
 
 static const match_table_t tokens = {
@@ -1200,6 +1200,7 @@ static const match_table_t tokens = {
 	{Opt_journal_dev, "journal_dev=%u"},
 	{Opt_journal_path, "journal_path=%s"},
 	{Opt_journal_checksum, "journal_checksum"},
+	{Opt_nojournal_checksum, "nojournal_checksum"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_abort, "abort"},
 	{Opt_data_journal, "data=journal"},
@@ -1381,6 +1382,8 @@ static const struct mount_opts {
 	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
 	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
+	{Opt_nojournal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
+	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
 	 MOPT_EXT4_ONLY | MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
@@ -4837,6 +4840,14 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
+	    test_opt(sb, JOURNAL_CHECKSUM)) {
+		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
+			 "during remount not supported");
+		err = -EINVAL;
+		goto restore_opts;
+	}
+
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "

