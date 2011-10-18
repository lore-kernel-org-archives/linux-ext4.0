From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] fs: optimize out 16 bytes worth of padding in struct inode
Date: Tue, 18 Oct 2011 10:49:15 -0400
Message-ID: <1318949355-17029-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50458 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab1JROtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Oct 2011 10:49:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rearrange the fields in struct inode so that on an x86_64 system,
fields that require 8-byte alignment don't end up causing 4-byte holes
in the structure.  It reduces the size of struct inode from 568 bytes
to 552 bytes.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

I plan to include this in the next push of ext4 to Linus,
unless there are any objections.

 include/linux/fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..c85398d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -775,7 +775,6 @@ struct inode {
 	struct timespec		i_atime;
 	struct timespec		i_mtime;
 	struct timespec		i_ctime;
-	unsigned int		i_blkbits;
 	blkcnt_t		i_blocks;
 
 #ifdef __NEED_I_SIZE_ORDERED
@@ -785,6 +784,7 @@ struct inode {
 	/* Misc */
 	unsigned long		i_state;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
+	unsigned int		i_blkbits;
 	struct mutex		i_mutex;
 
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
@@ -798,6 +798,7 @@ struct inode {
 		struct rcu_head		i_rcu;
 	};
 	atomic_t		i_count;
+	atomic_t		i_writecount;
 	u64			i_version;
 	unsigned short          i_bytes;
 	atomic_t		i_dio_count;
@@ -824,7 +825,6 @@ struct inode {
 #ifdef CONFIG_IMA
 	atomic_t		i_readcount; /* struct files open RO */
 #endif
-	atomic_t		i_writecount;
 	void			*i_private; /* fs or device private pointer */
 };
 
-- 
1.7.4.1.22.gec8e1.dirty

