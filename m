From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 5/5] ext2: convert to use the new truncate convention.
Date: Mon, 17 Aug 2009 18:44:12 +0200
Message-ID: <20090817164412.GK9962@wotan.suse.de>
References: <20090816102533.329473921@suse.de> <20090816102856.846088617@suse.de> <20090816201626.GA23048@infradead.org> <20090817064216.GC9962@wotan.suse.de> <4A893A82.6030801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZHQQoP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 12:44:15 -0400
Content-Disposition: inline
In-Reply-To: <4A893A82.6030801@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 17, 2009 at 02:09:54PM +0300, Boaz Harrosh wrote:
> On 08/17/2009 09:42 AM, Nick Piggin wrote:
> > On Sun, Aug 16, 2009 at 04:16:26PM -0400, Christoph Hellwig wrote:
> >> On Sun, Aug 16, 2009 at 08:25:38PM +1000, npiggin@suse.de wrote:
> >>> @@ -66,9 +68,10 @@ void ext2_delete_inode (struct inode * i
> >>>  	mark_inode_dirty(inode);
> >>>  	ext2_write_inode(inode, inode_needs_sync(inode));
> >>>  
> >>> +	/* XXX: where is truncate_inode_pages? */
> >>>  	inode->i_size = 0;
> >>>  	if (inode->i_blocks)
> >>> -		ext2_truncate (inode);
> >>> +		ext2_truncate_blocks(inode, 0);
> >>>  	ext2_free_inode (inode);
> >>
> >> At the beginning of the function, just before the diff window.  Because
> >> this is ->delete_inode we truncate away all pages, down to offset 0.
> > 
> > OK, weird. I thought I couldn't see it when I wrote that :) maybe my
> > tree was corrupted or I'm stupid.
> > 
> > 
> >>> +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
> >>> +{
> >>> +	/*
> >>> +	 * XXX: it seems like a bug here that we don't allow
> >>> +	 * IS_APPEND inode to have blocks-past-i_size trimmed off.
> >>> +	 * review and fix this.
> >>> +	 */
> >>> +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> >>> +	    S_ISLNK(inode->i_mode)))
> >>> +		return -EINVAL;
> >>> +	if (ext2_inode_is_fast_symlink(inode))
> >>> +		return -EINVAL;
> >>> +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> >>> +		return -EPERM;
> >>> +	__ext2_truncate_blocks(inode, offset);
> >>
> >> Yes, I think the IS_APPEND(inode) || IS_IMMUTABLE(inode) checks should move
> >> into ext2_setsize.  But let's leave that for a separate patch.
> > 
> > Yeah agreed.
> > 
> >  
> >> Btw, the above code gives me warnings like this:
> >>
> >> /home/hch/work/linux-2.6/fs/ext2/inode.c: In function
> >> 'ext2_truncate_blocks':
> >> /home/hch/work/linux-2.6/fs/ext2/inode.c:1158: warning: 'return' with a
> >> value, in function returning void
> >> /home/hch/work/linux-2.6/fs/ext2/inode.c:1160: warning: 'return' with a
> >> value, in function returning void
> >> /home/hch/work/linux-2.6/fs/ext2/inode.c:1162: warning: 'return' with a
> >> value, in function returning void
> >>
> >> because you try to return errors from a function delcared as void.
> > 
> > Hm, sorry. I thought it was in good shape... I'll recheck that I sent
> > out the correct versions and resend according to feedback from you
> > and Hugh.
> > 
> > Thanks,
> > Nick
> > 
> 
> Nick do you have a public tree with these latest patches? I would like to
> try out an exofs conversion and testing.

Hi Boaz,

I don't have a public tree. I can send you a rollup if you ping me or
just take the patches from the list. I will send out a new set shortly
(with very minor differences -- a couple of new helper functions to
use).

That will be great if you can convert your fs. I will really appreciate
it.

Thanks,
Nick
