From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch|rfc] ext4: fix race between unwritten extent conversion and truncate
Date: Thu, 26 Jan 2012 13:04:22 -0500
Message-ID: <x49liouz6ft.fsf@segfault.boston.devel.redhat.com>
References: <x491uqno6qv.fsf@segfault.boston.devel.redhat.com>
	<20120126170209.GE17113@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2AZSSA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 13:18:00 -0500
In-Reply-To: <20120126170209.GE17113@quack.suse.cz> (Jan Kara's message of
	"Thu, 26 Jan 2012 18:02:09 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>> --- a/fs/ext4/fsync.c
>> +++ b/fs/ext4/fsync.c
>> @@ -104,7 +104,7 @@ int ext4_flush_completed_IO(struct inode *inode)
>>  		 * queue work.
>>  		 */
>>  		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>> -		ret = ext4_end_io_nolock(io);
>> +		ret = ext4_end_io_nolock(io, false);
>   This is wrong. i_completed_io_list contains work items for both direct
> and buffered IO. Just in ext4_flush_completed_IO() we process the list
> synchronously while ext4_end_io_work() processes the list in the
> background. So what you have to do is store in ext4_io_end_t whether the IO
> was direct or not and then use that in ext4_end_io_nolock() function.

OK, thanks for the review.  Is the following what you had in mind?  If
so, I'll repost with a proper header.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 513004f..2d55d7c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -184,6 +184,7 @@ struct mpage_da_data {
 #define	EXT4_IO_END_UNWRITTEN	0x0001
 #define EXT4_IO_END_ERROR	0x0002
 #define EXT4_IO_END_QUEUED	0x0004
+#define EXT4_IO_END_DIRECT	0x0008
 
 struct ext4_io_page {
 	struct page	*p_page;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..f6dc02b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2795,9 +2795,6 @@ out:
 
 	/* queue the work to convert unwritten extents to written */
 	queue_work(wq, &io_end->work);
-
-	/* XXX: probably should move into the real I/O completion handler */
-	inode_dio_done(inode);
 }
 
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
@@ -2921,9 +2918,12 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		iocb->private = NULL;
 		EXT4_I(inode)->cur_aio_dio = NULL;
 		if (!is_sync_kiocb(iocb)) {
-			iocb->private = ext4_init_io_end(inode, GFP_NOFS);
-			if (!iocb->private)
+			ext4_io_end_t *io_end =
+				ext4_init_io_end(inode, GFP_NOFS);
+			if (!io_end)
 				return -ENOMEM;
+			io_end->flag |= EXT4_IO_END_DIRECT;
+			iocb->private = io_end;
 			/*
 			 * we save the io structure for current async
 			 * direct IO, so that later ext4_map_blocks()
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4758518..9e1b8eb 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -110,6 +110,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 	if (io->iocb)
 		aio_complete(io->iocb, io->result, 0);
 
+	if (io->flag & EXT4_IO_END_DIRECT)
+		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
 	if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
 		wake_up_all(ext4_ioend_wq(io->inode));
