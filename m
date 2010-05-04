From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Tue, 04 May 2010 12:49:26 -0700
Message-ID: <1273002566.3755.10.camel@mingming-laptop>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
	 <1272934667.2544.3.camel@mingming-laptop>  <4BE02C45.6010608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: djwong@us.ibm.com, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56094 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0EDTtc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 May 2010 15:49:32 -0400
In-Reply-To: <4BE02C45.6010608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2010-05-04 at 10:16 -0400, Ric Wheeler wrote:
> On 05/03/2010 08:57 PM, Mingming Cao wrote:
> > On Thu, 2010-04-29 at 16:51 -0700, Darrick J. Wong wrote:
> >    
> >> Hmm.  A while ago I was complaining that an evil program that calls fsync() in
> >> a loop will send a continuous stream of write barriers to the hard disk.  Ted
> >> theorized that it might be possible to set a flag in ext4_writepage and clear
> >> it in ext4_sync_file; if we happen to enter ext4_sync_file and the flag isn't
> >> set (meaning that nothing has been dirtied since the last fsync()) then we
> >> could skip issuing the barrier.
> >>
> >> Here's an experimental patch to do something sort of like that.  From a quick
> >> run with blktrace, it seems to skip the redundant barriers and improves the ffsb
> >> mail server scores.  However, I haven't done extensive power failure testing to
> >> see how much data it can destroy.  For that matter I'm not even 100% sure it's
> >> correct at what it aims to do.
> >>
> >> Just throwing this out there, though.  Nothing's blown up ... yet. :P
> >> ---
> >> Signed-off-by: Darrick J. Wong<djwong@us.ibm.com>
> >> ---
> >>
> >>   fs/ext4/ext4.h  |    2 ++
> >>   fs/ext4/fsync.c |    7 +++++--
> >>   fs/ext4/inode.c |    5 +++++
> >>   3 files changed, 12 insertions(+), 2 deletions(-)
> >>
> >>
> >> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >> index bf938cf..3b70195 100644
> >> --- a/fs/ext4/ext4.h
> >> +++ b/fs/ext4/ext4.h
> >> @@ -1025,6 +1025,8 @@ struct ext4_sb_info {
> >>
> >>   	/* workqueue for dio unwritten */
> >>   	struct workqueue_struct *dio_unwritten_wq;
> >> +
> >> +	atomic_t unflushed_writes;
> >>   };
> >>
> >>      
> > Just wondering is this per filesystem flag? Thought it is nicer to make
> > this per -inode flag, when there is no dirty data in fly for this inode
> > (instead of the whole fs), there is no need to call barrier in
> > ext4_sync_file().
> >
> > Mingming
> >    
> 
> Checking per inode is actually incorrect - we do not want to short cut 
> the need to flush the target storage device's write cache just because a 
> specific file has no dirty pages.  If a power hit occurs, having sent 
> the pages from to the storage device is not sufficient.
> 

hmm... My understanding is ext3/4 implementation of fsync syncing the
whole filesystem, as a jbd2 transacation could including metadata update
from other files, jbd2 has to commit the latest transactions.  But the
caller is fsync(), which should only need to ensure the specified
inode's dirty data/metadata gets to disk by sending barriers down.

Mingming

> I was thinking that it could actually be more general, specifically we 
> could track the status of the write cache on the entire storage device. 
> That way, any command (write, etc) to the target device would set the 
> cache state to needs_flush (or whatever) and the barrier flush would 
> clear it.
> 
> Probably not worth the complication...
> 
> ric
> 
> 
> >>   static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
> >> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> >> index 0d0c323..441f872 100644
> >> --- a/fs/ext4/fsync.c
> >> +++ b/fs/ext4/fsync.c
> >> @@ -52,7 +52,8 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
> >>   {
> >>   	struct inode *inode = dentry->d_inode;
> >>   	struct ext4_inode_info *ei = EXT4_I(inode);
> >> -	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> >> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> >> +	journal_t *journal = sbi->s_journal;
> >>   	int ret;
> >>   	tid_t commit_tid;
> >>      
> > ...
> >
> >    
> >> @@ -102,7 +103,9 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
> >>   		    (journal->j_flags&  JBD2_BARRIER))
> >>   			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
> >>   		jbd2_log_wait_commit(journal, commit_tid);
> >> -	} else if (journal->j_flags&  JBD2_BARRIER)
> >> +	} else if (journal->j_flags&  JBD2_BARRIER&&  atomic_read(&sbi->unflushed_writes)) {
> >> +		atomic_set(&sbi->unflushed_writes, 0);
> >>   		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
> >> +	}
> >>   	return ret;
> >>   }
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index 5381802..e501abd 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -2718,6 +2718,7 @@ static int ext4_writepage(struct page *page,
> >>   	unsigned int len;
> >>   	struct buffer_head *page_bufs = NULL;
> >>   	struct inode *inode = page->mapping->host;
> >> +	struct ext4_sb_info *sbi = EXT4_SB(page->mapping->host->i_sb);
> >>
> >>   	trace_ext4_writepage(inode, page);
> >>   	size = i_size_read(inode);
> >> @@ -2726,6 +2727,8 @@ static int ext4_writepage(struct page *page,
> >>   	else
> >>   		len = PAGE_CACHE_SIZE;
> >>
> >> +	atomic_set(&sbi->unflushed_writes, 1);
> >> +
> >>   	if (page_has_buffers(page)) {
> >>   		page_bufs = page_buffers(page);
> >>   		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> >> @@ -2872,6 +2875,8 @@ static int ext4_da_writepages(struct address_space *mapping,
> >>   	if (wbc->range_start == 0&&  wbc->range_end == LLONG_MAX)
> >>   		range_whole = 1;
> >>
> >> +	atomic_set(&sbi->unflushed_writes, 1);
> >> +
> >>   	range_cyclic = wbc->range_cyclic;
> >>   	if (wbc->range_cyclic) {
> >>   		index = mapping->writeback_index;
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>      
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >    
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


