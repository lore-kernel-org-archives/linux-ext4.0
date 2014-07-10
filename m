From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 3/5] tune2fs: remove_journal_device(): use the correct block to find jsb
Date: Thu, 10 Jul 2014 18:35:06 +0400
Message-ID: <1405002908-16332-4-git-send-email-a3at.mail@gmail.com>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Cc: darrick.wong@oracle.com, adilger@dilger.ca, tytso@mit.edu,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:50926 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaGJOf3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 10:35:29 -0400
Received: by mail-lb0-f179.google.com with SMTP id z11so6236211lbi.10
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 07:35:27 -0700 (PDT)
In-Reply-To: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/tune2fs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 9d21623..b395c7c 100644
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
-	if ((retval = io_channel_read_blk64(jfs->io, 1, -EXT2_SUPERBLOCK_SIZE, buf))) {
+	if ((retval = io_channel_read_blk64(jfs->io, start,
+	    -EXT2_SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval, "%s",
 			_("while reading journal superblock"));
 		goto no_valid_journal;
@@ -261,7 +264,8 @@ static int remove_journal_device(ext2_filsys fs)
 	jsb->s_nr_users = htonl(nr_users);
 
 	/* Write back the journal superblock */
-	if ((retval = io_channel_write_blk64(jfs->io, 1, -EXT2_SUPERBLOCK_SIZE, buf))) {
+	if ((retval = io_channel_write_blk64(jfs->io, start,
+	    -EXT2_SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval,
 			"while writing journal superblock.");
 		goto no_valid_journal;
-- 
2.0.0

