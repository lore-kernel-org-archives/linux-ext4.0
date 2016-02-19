From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Fri, 19 Feb 2016 14:18:29 +0100
Message-ID: <20160219131829.GA30166@quack.suse.cz>
References: <20160218054557.GH6338@birch.djwong.org>
 <20160218060148.GA10571@infradead.org>
 <20160218220232.GA4262@dastard>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbcBSNSG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 08:18:06 -0500
Content-Disposition: inline
In-Reply-To: <20160218220232.GA4262@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 19-02-16 09:02:32, Dave Chinner wrote:
> On Wed, Feb 17, 2016 at 10:01:48PM -0800, Christoph Hellwig wrote:
> > Might help to tell that this is on top of a direct-io.c patch from the
> > XFS tree.
> > 
> > I don't think clearing any flags is the right thing - now that we
> > always call ->end_io the code dealing with it in ext4_ext_direct_IO
> > can simply be moved to the ->end_io handler.
> > 
> > Something like the untested patch below:
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 9db04dd..b741c79 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3166,23 +3166,25 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> >  {
> >          ext4_io_end_t *io_end = iocb->private;
> >  
> > -	if (size <= 0)
> > -		return 0;
> > -
> >  	/* if not async direct IO just return */
> >  	if (!io_end)
> >  		return 0;
> >  
> > +	if (size <= 0) {
> > +		WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> > +		goto out;
> > +	}
> 
> That will still issue a warning when an I/O error occurs on an
> unwritten extent.

Ah, correct.

> > +
> >  	ext_debug("ext4_end_io_dio(): io_end 0x%p "
> >  		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
> >   		  iocb->private, io_end->inode->i_ino, iocb, offset,
> >  		  size);
> >  
> > -	iocb->private = NULL;
> >  	io_end->offset = offset;
> >  	io_end->size = size;
> > +out:
> >  	ext4_put_io_end(io_end);
> 
> Won't that now call ext4_put_io_end() ->
> ext4_convert_unwritten_extents() with an uninitialised offset and
> size?
> 
> i.e. I don't think this prevents warnings, and may make things
> worse when real errors occur....

Yeah, if IO error occurs while writing to unwritten extent we need to just
destroy the IO end without doing the extent conversion (since we don't know
how much got written). Attached patch should fix the issue - full xfstests
run is in progress but a quick check using generic/299 has passed.

How do we merge this? It depends on the changes in Dave's tree so do we
merge it via that? I have other ext4 changes pending in this area so Ted
would then have to pull some branch from Dave's tree. Guys?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--zYM0uCDKw75PZbzx
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-data-exposure-after-failed-AIO-DIO.patch"

>From fe96f559b86e609b8d98da03b5291a9a0da1d9a8 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 19 Feb 2016 13:53:11 +0100
Subject: [PATCH] ext4: Fix data exposure after failed AIO DIO

When AIO DIO fails e.g. due to IO error, we must not convert unwritten
extents as that will expose uninitialized data. Handle this case
by clearing unwritten flag from io_end in case of error and thus
preventing extent conversion.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    | 30 +++++++++++++++++++++---------
 fs/ext4/inode.c   | 21 ++++++++-------------
 fs/ext4/page-io.c | 10 ----------
 3 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0662b285dc8a..56c12df107ab 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1504,15 +1504,6 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
 
-static inline void ext4_set_io_unwritten_flag(struct inode *inode,
-					      struct ext4_io_end *io_end)
-{
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
-		io_end->flag |= EXT4_IO_END_UNWRITTEN;
-		atomic_inc(&EXT4_I(inode)->i_unwritten);
-	}
-}
-
 static inline ext4_io_end_t *ext4_inode_aio(struct inode *inode)
 {
 	return inode->i_private;
@@ -3293,6 +3284,27 @@ extern struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
 extern int ext4_resize_begin(struct super_block *sb);
 extern void ext4_resize_end(struct super_block *sb);
 
+static inline void ext4_set_io_unwritten_flag(struct inode *inode,
+					      struct ext4_io_end *io_end)
+{
+	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		io_end->flag |= EXT4_IO_END_UNWRITTEN;
+		atomic_inc(&EXT4_I(inode)->i_unwritten);
+	}
+}
+
+static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
+{
+	struct inode *inode = io_end->inode;
+
+	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
+		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
+		/* Wake up anyone waiting on unwritten extent conversion */
+		if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
+			wake_up_all(ext4_ioend_wq(inode));
+	}
+}
+
 #endif	/* __KERNEL__ */
 
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9db04dd9b88a..2b98171a9432 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3166,9 +3166,6 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 {
         ext4_io_end_t *io_end = iocb->private;
 
-	if (size <= 0)
-		return 0;
-
 	/* if not async direct IO just return */
 	if (!io_end)
 		return 0;
@@ -3179,6 +3176,14 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 		  size);
 
 	iocb->private = NULL;
+	/*
+	 * Error during AIO DIO. We cannot convert unwritten extents as the
+	 * data was not written. Just clear the unwritten flag and drop io_end.
+	 */
+	if (size <= 0) {
+		ext4_clear_io_unwritten_flag(io_end);
+		size = 0;
+	}
 	io_end->offset = offset;
 	io_end->size = size;
 	ext4_put_io_end(io_end);
@@ -3306,16 +3311,6 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	if (io_end) {
 		ext4_inode_aio_set(inode, NULL);
 		ext4_put_io_end(io_end);
-		/*
-		 * When no IO was submitted ext4_end_io_dio() was not
-		 * called so we have to put iocb's reference.
-		 */
-		if (ret <= 0 && ret != -EIOCBQUEUED && iocb->private) {
-			WARN_ON(iocb->private != io_end);
-			WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
-			ext4_put_io_end(io_end);
-			iocb->private = NULL;
-		}
 	}
 	if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
 						EXT4_STATE_DIO_UNWRITTEN)) {
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 090b3498638e..f49a87c4fb63 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -139,16 +139,6 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 	kmem_cache_free(io_end_cachep, io_end);
 }
 
-static void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
-{
-	struct inode *inode = io_end->inode;
-
-	io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
-	/* Wake up anyone waiting on unwritten extent conversion */
-	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
-		wake_up_all(ext4_ioend_wq(inode));
-}
--zYM0uCDKw75PZbzx--
