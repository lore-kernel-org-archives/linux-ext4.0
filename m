From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: Automatically allocate delay allocated blocks on close
Date: Tue, 24 Feb 2009 00:05:51 -0500
Message-ID: <1235451952-2726-6-git-send-email-tytso@mit.edu>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu>
 <1235451952-2726-2-git-send-email-tytso@mit.edu>
 <1235451952-2726-3-git-send-email-tytso@mit.edu>
 <1235451952-2726-4-git-send-email-tytso@mit.edu>
 <1235451952-2726-5-git-send-email-tytso@mit.edu>
Cc: aneesh.kumar@linux.vnet.ibm.com, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40269 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZBXFGE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 00:06:04 -0500
In-Reply-To: <1235451952-2726-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When closing a file that had been previously truncated, force any
delay allocated blocks that to be allocated so that if the filesystem
is mounted with data=ordered, the data blocks will be pushed out to
disk along with the journal commit.  Many application programs expect
this, so we do this to avoid zero length files if the system crashes
unexpectedly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/file.c  |    4 ++++
 fs/ext4/inode.c |    2 ++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 626bda7..b56245d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -269,6 +269,7 @@ static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 #define EXT4_STATE_NEW			0x00000002 /* inode is newly created */
 #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
 #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
+#define EXT4_STATE_DA_ALLOC_CLOSE	0x00000010 /* Alloc DA blks on close */
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f731cb5..06df827 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -33,6 +33,10 @@
  */
 static int ext4_release_file(struct inode *inode, struct file *filp)
 {
+	if (EXT4_I(inode)->i_state & EXT4_STATE_DA_ALLOC_CLOSE) {
+		ext4_alloc_da_blocks(inode);
+		EXT4_I(inode)->i_state &= ~EXT4_STATE_DA_ALLOC_CLOSE;
+	}
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c66af1c..22993ca 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3871,6 +3871,8 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
+	ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
+
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		ext4_ext_truncate(inode);
 		return;
-- 
1.5.6.3

