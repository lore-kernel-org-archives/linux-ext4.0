From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext4: nonda_switch prevent deadlock
Date: Thu, 30 Aug 2012 14:55:55 +0200
Message-ID: <20120830125555.GC4749@quack.suse.cz>
References: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org>
 <20120829132816.GB21169@quack.suse.cz>
 <87wr0g7u44.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	a-fujita@rs.jp.nec.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab2H3Mz7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2012 08:55:59 -0400
Content-Disposition: inline
In-Reply-To: <87wr0g7u44.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 30-08-12 10:48:43, Dmitry Monakhov wrote:
> On Wed, 29 Aug 2012 15:28:16 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Tue 28-08-12 20:21:41, Dmitry Monakhov wrote:
> > > Currently ext4_da_write_begin may deadlock if called with opened journal
> > > transaction. Real life example:
> > > ->move_extent_per_page()
> > >   ->ext4_journal_start()-> hold journal transaction
> > >   ->write_begin()
> > >     ->ext4_da_write_begin()
> > >       ->ext4_nonda_switch()
> > >         ->writeback_inodes_sb_if_idle()  --> will wait for journal_stop()
> > > 
> > > This bug may be easily fixed by code reordering,
> > > But in some cases it should be possible to call write_begin()
> > > while holding journal's transaction, in this case caller may avoid
> > > recoursion by passing AOP_FLAG_NOFS flag.
> >   Well, I find calling ext4_write_begin() with a transaction started a bug.
> > Possibly ext4_write_begin() can be tweaked to handle that but things would
> > be simpler if we didn't have to.
> > 
> > Looking into move_extent_per_page(), calling ->write_begin() doesn't seem
> > to be quite right there anyway. For example it results in filling holes
> > under that page which is not desirable. I'm not even sure why do we call
> > ->write_begin() there at all. The data in the page is unchanged. So it
> > should be enough to just remap buffers and mark the page dirty (but I might
> > be missing some subtlety here). Fujita-san, can you possibly explain?
> Yes, and No imho write_begin/write_end is not necessary here,
> but  simple marking page as dirty is not sufficient either because
> we end up files becomes zeroed if power failure during defrag procedure,
> as it now happen in case of delalloc
> start_journal()
> remap_page()
> set_page_dirty()
> stop_journal()
> ...15secs   <---- power failure
> write_back_page()
  Right, thanks for noticing this. Luckily that's rather easy to fix - just
do ext4_jbd2_file_inode() to make journal thread flush all dirty pages from
the inode before the transaction is committed.

> but in our case situation is even worse because good/oldfile
> will become corrupted so we have to somehow pin dirty pages to
> transaction similar to ordered mode.
> Currently i'm work on that approach which is simple but looks
> reliable: remap_procedure should looks like follows(error paths missed):
> 
> /* Double lock pages on two inodes, this is horrible but necessary */
> double_grab_page(struct inode *inode, struct inode *inode2,
>                          pgoff idx, struct page** pgvec1, page** pgvec2)
> {
>         if (mapping1 > mapping2) {
>             *pgvec1 = find_or_create_page(mapping1, idx, GFP_NOFS);
>             *pgvec2 = find_or_create_page(mapping2, idx, GFP_NOFS);
>         } else {
>             *pgvec2 = find_or_create_page(mapping2, idx, GFP_NOFS);
>             *pgvec1 = find_or_create_page(mapping1, idx, GFP_NOFS);
>         }
> }
> 
> move_extent () {
>      page * o_vec[32];
>      page * d_vec[32];
> 
> new_bio:
>      bio = bio_alloc()
>      bio->bi_sector = donor_extent->sector+start
>      ... /* other bio initialization */
>      /* start journal before lock pages */
>      journal_start();
>      for (idx = 0; idx <= end; idx++) {
>           double_grab_page(orig, donor, idx + start, o_vec + idx, d_vec + idx)
  I don't think you can lock several pages like this - you have to use
trylock to avoid deadlock...

>           make_page_uptodate_nounlock(o_vec + idx)
>           try_to_release_page(o_vec+idx)
>           try_to_release_page(d_vec+idx)
>           /* try to add page to bio which point to donor extent */
>           if (add_page_to_bio(bio, o_vec + idx))
>              continue;
> 
>          /* There is no mo space left in bio, it is time to submit it
>           * pages will be unlocked soon so we have to protest pages
>           * from modification via writeback bit, writeback will be
>           * cleared at bio_end_io
>           */    
>           for_each_page(o_vec, o_vec + idx, SetPageWriteback)
>           submit_bio(bio);
> 
>          /* After we submitted bio for io we can be shure that
>           * it will be flushed do disk before commit journal record
>           * because commit record request contain barrier,
>           * so effectively this bio pinned to transaction
>           */
  This isn't true. We can run without barriers and it's perfectly fine for
battery backed storage. But for your code to work, you have to wait for
storage to complete the bio before you replace the branches.

>          mext_replace_branches(orig, donor, start, start+idx)
> 
>          /* Ok we have complete remapping, it is now safe to unlock  pages */
>          for_each_page(o_vec, o_vec + idx, page_unlock)
>          for_each_page(d_vec, d_vec + idx, page_unlock)
>          start += idx;
>          goto new_bio:
>          }
> }
> This should works for any file types with data (with extra precautions for dir
> and symlinks)
  In principle, something like this should work but I think letting journal
thread handle the flushing is easier...

								Honza

> > > ---
> > >  fs/ext4/inode.c |   28 +++++++++++++++++-----------
> > >  1 files changed, 17 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 6324f74..d12d30e 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -889,6 +889,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
> > >  	struct page *page;
> > >  	pgoff_t index;
> > >  	unsigned from, to;
> > > +	int nofs = flags & AOP_FLAG_NOFS;
> > > +
> > > +	/* We cannot recurse into the filesystem if the transaction is already
> > > +	 * started */
> > > +	BUG_ON(!nofs && journal_current_handle());
> > >  
> > >  	trace_ext4_write_begin(inode, pos, len, flags);
> > >  	/*
> > > @@ -906,9 +911,6 @@ retry:
> > >  		ret = PTR_ERR(handle);
> > >  		goto out;
> > >  	}
> > > -
> > > -	/* We cannot recurse into the filesystem as the transaction is already
> > > -	 * started */
> > >  	flags |= AOP_FLAG_NOFS;
> > >  
> > >  	page = grab_cache_page_write_begin(mapping, index, flags);
> > > @@ -957,7 +959,8 @@ retry:
> > >  		}
> > >  	}
> > >  
> > > -	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> > > +	if (!nofs && ret == -ENOSPC &&
> > > +	    ext4_should_retry_alloc(inode->i_sb, &retries))
> > >  		goto retry;
> > >  out:
> > >  	return ret;
> > > @@ -2447,7 +2450,7 @@ out_writepages:
> > >  }
> > >  
> > >  #define FALL_BACK_TO_NONDELALLOC 1
> > > -static int ext4_nonda_switch(struct super_block *sb)
> > > +static int ext4_nonda_switch(struct super_block *sb, int writeback_allowed)
> > >  {
> > >  	s64 free_blocks, dirty_blocks;
> > >  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > > @@ -2475,7 +2478,7 @@ static int ext4_nonda_switch(struct super_block *sb)
> > >  	 * Even if we don't switch but are nearing capacity,
> > >  	 * start pushing delalloc when 1/2 of free blocks are dirty.
> > >  	 */
> > > -	if (free_blocks < 2 * dirty_blocks)
> > > +	if (writeback_allowed && free_blocks < 2 * dirty_blocks)
> > >  		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
> > >  
> > >  	return 0;
> > > @@ -2490,10 +2493,14 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
> > >  	pgoff_t index;
> > >  	struct inode *inode = mapping->host;
> > >  	handle_t *handle;
> > > +	int nofs = flags & AOP_FLAG_NOFS;
> > >  
> > >  	index = pos >> PAGE_CACHE_SHIFT;
> > > +	/* We cannot recurse into the filesystem if the transaction is already
> > > +	 * started */
> > > +	BUG_ON(!nofs && journal_current_handle());
> > >  
> > > -	if (ext4_nonda_switch(inode->i_sb)) {
> > > +	if (ext4_nonda_switch(inode->i_sb, !nofs)) {
> > >  		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
> > >  		return ext4_write_begin(file, mapping, pos,
> > >  					len, flags, pagep, fsdata);
> > > @@ -2512,8 +2519,6 @@ retry:
> > >  		ret = PTR_ERR(handle);
> > >  		goto out;
> > >  	}
> > > -	/* We cannot recurse into the filesystem as the transaction is already
> > > -	 * started */
> > >  	flags |= AOP_FLAG_NOFS;
> > >  
> > >  	page = grab_cache_page_write_begin(mapping, index, flags);
> > > @@ -2538,7 +2543,8 @@ retry:
> > >  			ext4_truncate_failed_write(inode);
> > >  	}
> > >  
> > > -	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> > > +	if (!nofs && ret == -ENOSPC &&
> > > +	    ext4_should_retry_alloc(inode->i_sb, &retries))
> > >  		goto retry;
> > >  out:
> > >  	return ret;
> > > @@ -4791,7 +4797,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > >  	/* Delalloc case is easy... */
> > >  	if (test_opt(inode->i_sb, DELALLOC) &&
> > >  	    !ext4_should_journal_data(inode) &&
> > > -	    !ext4_nonda_switch(inode->i_sb)) {
> > > +	    !ext4_nonda_switch(inode->i_sb, 1)) {
> > >  		do {
> > >  			ret = __block_page_mkwrite(vma, vmf,
> > >  						   ext4_da_get_block_prep);
> > > -- 
> > > 1.7.7.6
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
