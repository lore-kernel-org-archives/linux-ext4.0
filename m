From: Jan Kara <jack@suse.cz>
Subject: [PATCH] mke2fs: Make lost+found always have at least two blocks
Date: Thu, 6 Dec 2007 15:15:46 +0100
Message-ID: <20071206141546.GB6396@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33345 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbXLFOPr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Dec 2007 09:15:47 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  attached patch modifies mke2fs to always create lost+found with at least
two directory blocks. I think this could make sence not only for testing
but as a sanity check that 64KB support works for general e2fsprogs if
someone decides to use it...

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
