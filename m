From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] vfs: Block mmapped writes while the fs is frozen
Date: Thu, 19 May 2011 14:08:16 +0200
Message-ID: <20110519120816.GG8417@quack.suse.cz>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <1305731882-8334-3-git-send-email-jack@suse.cz>
 <20110518181206.GB10163@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab1ESMIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 08:08:37 -0400
Content-Disposition: inline
In-Reply-To: <20110518181206.GB10163@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-05-11 14:12:06, Christoph Hellwig wrote:
> >  
> >  	if (unlikely(ret < 0))
> >  		unlock_page(page);
> > +	else {
> > +		/*
> > +		 * Freezing in progress? We check after the page is marked
> > +		 * dirty and with page lock held so if the test here fails, we
> > +		 * are sure freezing code will wait during syncing until the
> > +		 * page fault is done - at that point page will be dirty and
> > +		 * unlocked so freezing code will write it and writeprotect it
> > +		 * again.
> > +		 */
> > +		set_page_dirty(page);
> > +		if (inode->i_sb->s_frozen != SB_UNFROZEN) {
> > +			unlock_page(page);
> > +			ret = -EAGAIN;
> > +			goto out;
> > +		}
> > +	}
> >  out:
> >  	return ret;
> 
> The code structure looks a bit odd, why not:
> 
> 	if (ret < 0)
> 		goto out_unlock;
> 
> 	set_page_dirty(page);
> 	if (inode->i_sb->s_frozen != SB_UNFROZEN) {
> 		ret = -EAGAIN;
> 		goto out_unlock;
> 	}
> 
> 	return 0;
> 
> out_unlock:
> 	unlock_page(page);
> 	return ret;
> }
> 
> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
  Thanks, I've changed the flow as you suggested.

								Honza
