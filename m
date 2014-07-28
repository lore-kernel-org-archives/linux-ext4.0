From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 2/4 v3] tune2fs: remove_journal_device(): use the correct block to find jsb
Date: Mon, 28 Jul 2014 11:43:23 +0400
Message-ID: <1406533405-6899-3-git-send-email-a3at.mail@gmail.com>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Cc: tytso@mit.edu, darrick.wong@oracle.com, adilger@dilger.ca,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:33377 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaG1Hn7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:43:59 -0400
Received: by mail-la0-f50.google.com with SMTP id gf5so5225503lab.9
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 00:43:57 -0700 (PDT)
In-Reply-To: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/tune2fs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ff50f37..1df655a 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -188,6 +188,7 @@ static int remove_journal_device(ext2_filsys fs)
 	errcode_t	retval;
 	int		commit_remove_journal = 0;
 	io_manager	io_ptr;
+	int start;
 
 	if (f_flag)
 		commit_remove_journal = 1; /* force removal even if error */
@@ -224,8 +225,10 @@ static int remove_journal_device(ext2_filsys fs)
 		goto no_valid_journal;
 	}
 
+	start = ext2fs_journal_sb_start(fs->blocksize);
 	/* Get the journal superblock */
-	if ((retval = io_channel_read_blk64(jfs->io, 1, -SUPERBLOCK_SIZE, buf))) {
+	if ((retval = io_channel_read_blk64(jfs->io, start,
+	    -SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval, "%s",
 			_("while reading journal superblock"));
 		goto no_valid_journal;
@@ -256,7 +259,8 @@ static int remove_journal_device(ext2_filsys fs)
 	jsb->s_nr_users = htonl(nr_users);
 
 	/* Write back the journal superblock */
-	if ((retval = io_channel_write_blk64(jfs->io, 1, -SUPERBLOCK_SIZE, buf))) {
+	if ((retval = io_channel_write_blk64(jfs->io, start,
+	    -SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval,
 			"while writing journal superblock.");
 		goto no_valid_journal;
-- 
2.0.1

