From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] fs: Create __block_page_mkwrite() helper passing
 error values back
Date: Wed, 18 May 2011 09:35:32 +0200
Message-ID: <20110518073532.GA25632@quack.suse.cz>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <1305066574-1573-2-git-send-email-jack@suse.cz>
 <20110517150903.GA6653@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1ERHfx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 03:35:53 -0400
Content-Disposition: inline
In-Reply-To: <20110517150903.GA6653@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 17-05-11 11:09:03, Christoph Hellwig wrote:
> > +	if (unlikely(ret < 0))
> >  		unlock_page(page);
> > +	else
> >  		ret = VM_FAULT_LOCKED;
> >  out:
> >  	return ret;
> 
> Using two different types of return values here seems rather unclean.
> I'd rather use 0 instead of VM_FAULT_LOCKED here, and maybe overload
> -EAGAIN for VM_FAULT_NOPAGE.
  OK, makes sense. I'll do that.

> > +int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> > +		   get_block_t get_block)
> > +{
> > +	int ret = __block_page_mkwrite(vma, vmf, get_block);
> > +
> > +	if (unlikely(ret < 0)) {
> > +		if (ret == -ENOMEM)
> > +			return VM_FAULT_OOM;
> > +		/* -ENOSPC, -EIO, etc */
> > +		return VM_FAULT_SIGBUS;
> > +	}
> > +	return ret;
> 
> and maybe also add a small inlined block_page_mkwrite_error helper
> to translate the values.
  Good idea.

> Alternatively it might make sense to add a VM_FAULT_ENOSPC return value
> so that you could re-use block_page_mkwrite unmodified, and we could
> also have better error reporting for that case for the core VM.
  Umm, I think the first solution is better. For example ext[34] needs to
differentiate ENOSPC and EDQUOT (for the second one it does not make sense
to force transaction commit because quota accounting is always precise) and
other filesystems might possibly have different requirements. So returning
the error value and letting fs sort it out looks like the most versatile
solution.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
