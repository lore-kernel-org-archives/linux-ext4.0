From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Performance of ext4
Date: Tue, 24 Jun 2008 09:03:49 +0530
Message-ID: <20080624033349.GD10469@skywalker>
References: <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu> <485A8C2D.1090806@redhat.com> <20080619174211.GB9119@mit.edu> <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de> <20080620085922.GH9119@mit.edu> <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de> <20080623174508.GA7216@skywalker> <1214267492.27507.285.camel@BVR-FS.beaverton.ibm.com> <20080624030721.GB10469@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34642 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752549AbYFXDeL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 23:34:11 -0400
Content-Disposition: inline
In-Reply-To: <20080624030721.GB10469@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 24, 2008 at 08:37:21AM +0530, Aneesh Kumar K.V wrote:
> On Mon, Jun 23, 2008 at 05:31:32PM -0700, Mingming wrote:
> > 
> > On Mon, 2008-06-23 at 23:15 +0530, Aneesh Kumar K.V wrote:
> > 
> > > I found one place where we fail to update i_disksize. Can you try this
> > > patch ?
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 33f940b..9fa737f 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -1620,7 +1620,10 @@ static int ext4_da_writepage(struct page *page,
> > >  	loff_t size;
> > >  	unsigned long len;
> > >  	handle_t *handle = NULL;
> > > +	ext4_lblk_t block;
> > > +	loff_t disksize;
> > >  	struct buffer_head *page_bufs;
> > > +	struct buffer_head *bh, *head;
> > >  	struct inode *inode = page->mapping->host;
> > > 
> > >  	handle = ext4_journal_current_handle();
> > > @@ -1662,6 +1665,38 @@ static int ext4_da_writepage(struct page *page,
> > >  	else
> > >  		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
> > > 
> > > +	 if (ret)
> > > +		 return ret;
> > > +	/*
> > > +	 * When called via shrink_page_list and if we don't have any unmapped
> > > +	 * buffer_head we still could have written some new content in an
> > > +	 * already mapped buffer. That means we need to extent i_disksize here
> > > +	 */
> > 
> > In this case(when extend the file without need block allocation),
> > wouldn't make sense to update the i_disksize at write_end() time? So
> > that the window of i_size different from i_disksize could be much
> > smaller in this case.
> > 
> > 
> > Something like below? (untested)
> 
> In this case you will have to start a transaction in write_begin . With
> the below code transaction is started inside page_lock. Also I don't
> think we need needed_blocks credit just 1 should be enough because we
> are not doing any block allocation here. We just need to update the
> inode block.
> 
> 

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 33f940b..bc925c5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1770,6 +1770,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
+	handle_t *handle;
 	struct inode *inode = mapping->host;
 
 	index = pos >> PAGE_CACHE_SHIFT;
@@ -1777,6 +1778,17 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	to = from + len;
 
 retry:
+	/*
+	 * If we are writing towards the end of an already mapped
+	 * buffer_head, we don't do any block allocation. But we
+	 * need to update i_disksize.
+	 */
+	handle = ext4_journal_start(inode, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
 	page = __grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
@@ -1786,15 +1798,63 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 							ext4_da_get_block_prep);
 	if (ret < 0) {
 		unlock_page(page);
+		ext4_journal_stop(handle);
 		page_cache_release(page);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
+out:
 	return ret;
 }
 
+static int ext4_da_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	loff_t new_i_size;
+	unsigned from, to;
+	int ret = 0, ret2;
+	struct inode *inode = mapping->host;
+	handle_t *handle = ext4_journal_current_handle();
+
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
+	/*
+	 * generic_write_end() will run mark_inode_dirty() if i_size
+	 * changes.  So let's piggyback the i_disksize mark_inode_dirty
+	 * into that.
+	 */
+
+	new_i_size = pos + copied;
+	if (new_i_size > EXT4_I(inode)->i_disksize)
+		if (!walk_page_buffers(NULL, page_buffers(page),
+					0, len, NULL,
+					ext4_bh_unmapped_or_delay)) {
+			/*
+			 * Updating i_disksize when extending file without
+			 * need block allocation
+			 */
+			if (ext4_should_order_data(inode))
+				ret = ext4_jbd2_file_inode(handle, inode);
+
+			EXT4_I(inode)->i_disksize = new_i_size;
+		}
+	ret2 = generic_write_end(file, mapping, pos,
+			len, copied, page, fsdata);
+	copied = ret2;
+	if (ret2 < 0)
+		ret = ret2;
+	ret2 = ext4_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+
+	return ret ? ret : copied;
+}
+
 static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
 {
 	/*
@@ -2250,7 +2310,7 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	.writepages	= ext4_da_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= ext4_da_write_begin,
-	.write_end	= generic_write_end,
+	.write_end	= ext4_da_write_end,
 	.bmap		= ext4_bmap,
 	.invalidatepage	= ext4_da_invalidatepage,
 	.releasepage	= ext4_releasepage,
