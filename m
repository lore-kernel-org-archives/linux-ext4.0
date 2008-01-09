From: Jan Kara <jack@suse.cz>
Subject: [PATCH resend] mke2fs: Make lost+found always have at least 2
	blocks
Date: Wed, 9 Jan 2008 20:59:47 +0100
Message-ID: <20080109195947.GE2215@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35344 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbYAIT7t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 14:59:49 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  this is a resend of Andreas' patch I've sent in the beginning of
December. The patch modifies mke2fs to always create lost+found with at
least two directory blocks. I think this could make sence not only for
testing but as a sanity check that 64KB support works for general e2fsprogs
if someone decides to use it...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

From: Andreas Dilger <adilger@sun.com>

Make sure lost+found has always at least 2 disk blocks. This will provide at
least elementary test that we have not screwed-up support for 64KB blocks since
the second directory block will be empty.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 98a4957..6249cc2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -534,7 +534,10 @@ static void create_lost_and_found(ext2_f
 	}
 	
 	for (i=1; i < EXT2_NDIR_BLOCKS; i++) {
-		if ((lpf_size += fs->blocksize) >= 16*1024)
+		/* Ensure that lost+found is at least 2 blocks, so we always
+		 * test large empty blocks for big-block filesystems.  */
+		if ((lpf_size += fs->blocksize) >= 16*1024 &&
+		    lpf_size >= 2 * fs->blocksize)
 			break;
 		retval = ext2fs_expand_dir(fs, ino);
 		if (retval) {
