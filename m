From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 07/10] ext4: inode: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:02 +0530
Message-ID: <1350414785-7848-7-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed coding style issue reported by checkpatch.pl

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/inode.c b/linux-3.7-rc1/fs/ext4/inode.c
index b3c243b..a174620 100644
--- a/linux-3.7-rc1/fs/ext4/inode.c
+++ b/linux-3.7-rc1/fs/ext4/inode.c
@@ -2880,7 +2880,7 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 			    bool is_async)
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
-        ext4_io_end_t *io_end = iocb->private;
+	ext4_io_end_t *io_end = iocb->private;
 
 	/* if not async direct IO or dio with 0 bytes write, just return */
 	if (!io_end || !size)
@@ -3435,9 +3435,9 @@ static int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 		zero_user(page, pos, range_to_discard);
 
 		err = 0;
-		if (ext4_should_journal_data(inode)) {
+		if (ext4_should_journal_data(inode))
 			err = ext4_handle_dirty_metadata(handle, inode, bh);
-		} else
+		else
 			mark_buffer_dirty(bh);
 
 		BUFFER_TRACE(bh, "Partial buffer zeroed");
-- 
1.7.7.3
