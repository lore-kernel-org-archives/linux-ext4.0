From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check io list state and avoid an unnecessary
 mutex_lock in ext4_end_io_work.
Date: Sat, 29 Oct 2011 16:57:40 -0400
Message-ID: <20111029205740.GB16825@thunk.org>
References: <1315989182-6170-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60542 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab1J2U5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 16:57:46 -0400
Content-Disposition: inline
In-Reply-To: <1315989182-6170-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 04:33:02PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we finish the end io work in ext4_flush_completed_IO, we take
> the io work away from the list, but don't free it. Then in the workqueue,
> we can check the list state and then avoid the extra work if it is also
> done. It is good, but we check list state in ext4_end_io_nolock with i_mutex held
> instead of the spin_lock in other places. This is wrong.

Hi Tao,

Thanks for finding and pointing out this bug in ext4_end_io_nolock().
Unfortunately your proposed fix doesn't take into account that there
are other callers of ext4_end_io_nolock() besides ext4_end_io_work(),
and so it's not sufficient to move the test from former function to
the latter.

Attached please find the patch which I am planning to check into the
ext4 tree to address this bug which you have pointed out.

Regards,

						- Ted

commit c0e36d8410bfad4db4edefeb4175f85a5d216c8d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Oct 29 16:57:19 2011 -0400

    ext4: use spinlock before checking io->list in ext4_io_end_nolock()
    
    In ext4_end_io_nolock(), io->list is checked to see if it is empty
    without taking the ei->i_completed_io_lock spinlock.  This violates
    the locking protocol, and can cause very hard to debug failures.
    
    Also optimize ext4_end_io_work() so that if ext4_end_io_nolock() is
    not going to do any work, don't try getting the i_mutex and possibly
    requeuing the end_io request if the trylock doesn't succeed in grabbing
    the mutex.
    
    Thanks to Tao Ma <boyu.mt@taobao.com> for spotting the error and
    providing an initial fix to address the problem.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Tao Ma <boyu.mt@taobao.com>

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 92f38ee..0af5607 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -90,21 +90,27 @@ void ext4_free_io_end(ext4_io_end_t *io)
  */
 int ext4_end_io_nolock(ext4_io_end_t *io)
 {
-	struct inode *inode = io->inode;
-	loff_t offset = io->offset;
-	ssize_t size = io->size;
-	wait_queue_head_t *wq;
-	int ret = 0;
+	unsigned long		flags;
+	struct inode		*inode = io->inode;
+	loff_t			offset = io->offset;
+	ssize_t			size = io->size;
+	struct ext4_inode_info	*ei = EXT4_I(inode);
+	wait_queue_head_t	*wq;
+	int			ret;
 
 	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
 
-	if (list_empty(&io->list))
-		return ret;
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	if (list_empty(&io->list)) {
+		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	if (!(io->flag & EXT4_IO_END_UNWRITTEN))
-		return ret;
+		return 0;
 
 	ret = ext4_convert_unwritten_extents(inode, offset, size);
 	if (ret < 0) {
@@ -142,6 +148,16 @@ static void ext4_end_io_work(struct work_struct *work)
 	unsigned long		flags;
 	int			ret;
 
+	if (!(io->flag & EXT4_IO_END_UNWRITTEN))
+		goto free_io_end;
+
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	if (list_empty(&io->list)) {
+		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+		goto free_io_end;
+	}
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+
 	if (!mutex_trylock(&inode->i_mutex)) {
 		/*
 		 * Requeue the work instead of waiting so that the work
@@ -170,6 +186,7 @@ static void ext4_end_io_work(struct work_struct *work)
 		list_del_init(&io->list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 	mutex_unlock(&inode->i_mutex);
+free_io_end:
 	ext4_free_io_end(io);
 }
 
