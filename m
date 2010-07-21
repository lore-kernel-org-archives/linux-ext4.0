From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
	no dirty pages.
Date: Wed, 21 Jul 2010 19:16:09 +0200
Message-ID: <20100721171609.GC1215@atrey.karlin.mff.cuni.cz>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org> <4C2B44C0.3090002@redhat.com> <20100630134429.GE1333@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
To: tytso@mit.edu, Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35827 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753213Ab0GURQL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jul 2010 13:16:11 -0400
Content-Disposition: inline
In-Reply-To: <20100630134429.GE1333@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

> On Wed, Jun 30, 2010 at 09:21:04AM -0400, Ric Wheeler wrote:
> > 
> > The problem with not issuing a cache flush when you have dirty meta
> > data or data is that it does not have any tie to the state of the
> > volatile write cache of the target storage device.
> 
> We track whether or not there is any metadata updates associated with
> the inode already; if it does, we force a journal commit, and this
> implies a barrier operation.
> 
> The case we're talking about here is one where either (a) there is no
> journal, or (b) there have been no metadata updates (I'm simplifying a
> little here; in fact we track whether there have been fdatasync()- vs
> fsync()- worthy metadata updates), and so there hasn't been a journal
> commit to do the cache flush.
> 
> In this case, we want to track when is the last time an fsync() has
> been issued, versus when was the last time data blocks for a
> particular inode have been pushed out to disk.
> 
> To use an example I used as motivation for why we might want an
> fsync2(int fd[], int flags[], int num) syscall, consider the situation
> of:
> 
> 	fsync(control_fd);
> 	fdatasync(data_fd);
> 
> The first fsync() will have executed a cache flush operation.  So when
> we do the fdatasync() (assuming that no metadata needs to be flushed
> out to disk), there is no need for the cache flush operation.
> 
> If we had an enhanced fsync command, we would also be able to
> eliminate a second journal commit in the case where data_fd also had
> some metadata that needed to be flushed out to disk.
  Current implementation already avoids journal commit because of
fdatasync(data_fd). We remeber a transaction ID when inode metadata has
last been updated and do not force a transaction commit if it is already
committed. Thus the first fsync might force a transaction commit but second
fdatasync likely won't.
  We could actually improve the scheme to work for data as well. I wrote
a proof-of-concept patches (attached) and they nicely avoid second barrier
when doing:
echo "aaa" >file1; echo "aaa" >file2; fsync file2; fsync file1

  Ted, would you be interested in something like this?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--3MwIy2ne0vdjdPXF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-block-Introduce-barrier-counters.patch"

>From 542e237ea9ddbc17b54bf3b6b8d964b58f311b94 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 21 Jul 2010 17:09:09 +0200
Subject: [PATCH 1/2] block: Introduce barrier counters

Introduce a barrier counters to the block device that are incremented each time
before we send a barrier and after the barrier is completed.  Filesystems can
then use this counter to verify whether they need to issue a barrier to flush
file's data during fsync.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-core.c   |    5 +++++
 fs/bio.c           |    7 +++++++
 include/linux/fs.h |    4 ++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f0640d7..6fc58e6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1600,6 +1600,11 @@ void submit_bio(int rw, struct bio *bio)
 				bdevname(bio->bi_bdev, b));
 		}
 	}
+	if (rw & (1 << BIO_RW_BARRIER)) {
+		atomic_inc(&bio->bi_bdev->bd_barriers_sent);
+		/* Make sure counter update is seen before IO happens */
+		smp_mb__after_atomic_inc();
+	}
 
 	generic_make_request(bio);
 }
diff --git a/fs/bio.c b/fs/bio.c
index e7bf6ca..59f01cb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1427,6 +1427,13 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	/*
+	 * Increment even in case of error so that sent and completed
+	 * counters don't get out of sync
+	 */
+	if (bio_rw_flagged(bio, BIO_RW_BARRIER))
+		atomic_inc(&bio->bi_bdev->bd_barriers_completed);
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68ca1b0..4a6c91d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -654,6 +654,10 @@ struct block_device {
 	void *			bd_claiming;
 	void *			bd_holder;
 	int			bd_holders;
+	/* Incremented each time before we send a barrier */
+	atomic_t		bd_barriers_sent;
+	/* Incremented each time after a barrier request completes */
+	atomic_t		bd_barriers_completed;
 #ifdef CONFIG_SYSFS
 	struct list_head	bd_holder_list;
 #endif
-- 
1.6.4.2


--3MwIy2ne0vdjdPXF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-ext4-Send-barriers-on-fsync-only-when-needed.patch"

>From 4fe836d5554dc8cb0732af1f4e5b317d7e59febf Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 21 Jul 2010 19:01:51 +0200
Subject: [PATCH 2/2] ext4: Send barriers on fsync only when needed

It isn't necessary to send a barrier to disk for fsync of file 'f'
when we already sent one after all the data of 'f' have been written.
Implement logic to detect this condition and avoid sending barrier
in this case.

We use counters of submitted and completed IO barriers for a block device.
When a page is written to the block device, we store current number of
barriers submitted in the inode. When we handle fsync, we check whether
the number of completed barriers is at least that large.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |    4 +++-
 fs/ext4/fsync.c |   19 +++++++++++++++++--
 fs/ext4/inode.c |    4 ++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..cc67e72 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -832,10 +832,12 @@ struct ext4_inode_info {
 
 	/*
 	 * Transactions that contain inode's metadata needed to complete
-	 * fsync and fdatasync, respectively.
+	 * fsync and fdatasync, respectively and barrier id when we last
+	 * wrote data to this file.
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+	unsigned i_data_bid;
 };
 
 /*
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 592adf2..d8a6995 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -57,6 +57,21 @@ static void ext4_sync_parent(struct inode *inode)
 	}
 }
 
+static int ext4_need_issue_data_flush(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	int comp_bid, inode_bid = ei->i_data_bid;
+
+	if (!(journal->j_flags & JBD2_BARRIER))
+		return 0;
+	comp_bid = atomic_read(&inode->i_sb->s_bdev->bd_barriers_completed);
+	/* inode_bid < completed_bid safe against wrapping */
+	if (inode_bid - comp_bid < 0)
+		return 0;
+	return 1;
+}
+
 /*
  * akpm: A new design for ext4_sync_file().
  *
@@ -126,11 +141,11 @@ int ext4_sync_file(struct file *file, int datasync)
 		 */
 		if (ext4_should_writeback_data(inode) &&
 		    (journal->j_fs_dev != journal->j_dev) &&
-		    (journal->j_flags & JBD2_BARRIER))
+		    ext4_need_issue_data_flush(inode))
 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
 					NULL, BLKDEV_IFL_WAIT);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
-	} else if (journal->j_flags & JBD2_BARRIER)
+	} else if (ext4_need_issue_data_flush(inode))
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
 			BLKDEV_IFL_WAIT);
 	return ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..8d57aae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2758,6 +2758,10 @@ static int ext4_writepage(struct page *page,
 	} else
 		ret = block_write_full_page(page, noalloc_get_block_write,
 					    wbc);
+	/* Make sure we read current value of bd_barriers_sent */
+	smp_rmb();
+	EXT4_I(inode)->i_data_bid =
+		atomic_read(&inode->i_sb->s_bdev->bd_barriers_sent);
 
 	return ret;
 }
-- 
1.6.4.2


--3MwIy2ne0vdjdPXF--
