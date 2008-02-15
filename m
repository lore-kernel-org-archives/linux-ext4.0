From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: Set directory link count to zero if we fail to
	create the directory.
Date: Fri, 15 Feb 2008 14:23:30 -0500
Message-ID: <20080215192329.GA2773@mit.edu>
References: <1202834708-961-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55928 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757709AbYBPAI1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2008 19:08:27 -0500
Content-Disposition: inline
In-Reply-To: <1202834708-961-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've replaced this patch with the following (see attached).  The
changes to the patch from Aneesh's original one are:

1) Replace the patch description with one that describes what is going
   on at a higher level.  (Always write with a deep sympathy for the
   reader, who will be reading the description as part of "git log".
   So mention that the problem was in ext4_mkdir, and the
   circumstances in which it would occur.)

2) The error handling code was duplicated later in the function
   (although in a slightly more efficient fashion; since we *know* the
   newly created inode has an inode->i_nlink of 1, it's easier just to
   set i_nlink to zero)

3) Replace the inode->i_nlink = 0 with the higher level equivalent
   inline function, clear_nlink(inode).

						- Ted

ext4: Don't leave behind a half-created inode if ext4_mkdir() fails

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

If ext4_mkdir() fails to allocate the initial block for the directory,
don't leave behind a half-created directory inode with the link count
left at one.  This was caused by an inappropriate call to ext4_dec_count().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a9347fb..7970e81 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1804,12 +1804,8 @@ retry:
 	inode->i_fop = &ext4_dir_operations;
 	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
 	dir_block = ext4_bread (handle, inode, 0, 1, &err);
-	if (!dir_block) {
-		ext4_dec_count(handle, inode); /* is this nlink == 0? */
-		ext4_mark_inode_dirty(handle, inode);
-		iput (inode);
-		goto out_stop;
-	}
+	if (!dir_block)
+		goto out_clear_inode;
 	BUFFER_TRACE(dir_block, "get_write_access");
 	ext4_journal_get_write_access(handle, dir_block);
 	de = (struct ext4_dir_entry_2 *) dir_block->b_data;
@@ -1832,7 +1828,8 @@ retry:
 	ext4_mark_inode_dirty(handle, inode);
 	err = ext4_add_entry (handle, dentry, inode);
 	if (err) {
-		inode->i_nlink = 0;
+	out_clear_inode:
+		clear_nlink(inode);
 		ext4_mark_inode_dirty(handle, inode);
 		iput (inode);
 		goto out_stop;
