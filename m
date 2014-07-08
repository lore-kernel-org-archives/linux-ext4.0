From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 2/3] tune2fs: remove_journal_device(): use the correct block to find jsb
Date: Wed,  9 Jul 2014 00:41:21 +0400
Message-ID: <1404852082-1550-3-git-send-email-a3at.mail@gmail.com>
References: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com>
Cc: tytso@mit.edu, Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42211 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbaGHUlm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 16:41:42 -0400
Received: by mail-lb0-f177.google.com with SMTP id u10so4262161lbd.8
        for <linux-ext4@vger.kernel.org>; Tue, 08 Jul 2014 13:41:41 -0700 (PDT)
In-Reply-To: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 misc/tune2fs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 0e7caf2..811cb4d 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -193,6 +193,7 @@ static int remove_journal_device(ext2_filsys fs)
 	errcode_t	retval;
 	int		commit_remove_journal = 0;
 	io_manager	io_ptr;
+	int start;
 
 	if (f_flag)
 		commit_remove_journal = 1; /* force removal even if error */
@@ -229,8 +230,10 @@ static int remove_journal_device(ext2_filsys fs)
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
@@ -261,7 +264,8 @@ static int remove_journal_device(ext2_filsys fs)
 	jsb->s_nr_users = htonl(nr_users);
 
 	/* Write back the journal superblock */
-	if ((retval = io_channel_write_blk64(jfs->io, 1, -SUPERBLOCK_SIZE, buf))) {
+	if ((retval = io_channel_write_blk64(jfs->io, start,
+	    -SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval,
 			"while writing journal superblock.");
 		goto no_valid_journal;
-- 
2.0.0

