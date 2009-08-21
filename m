From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 06/11] ext2: convert to use the new truncate convention.
Date: Fri, 21 Aug 2009 16:06:59 +0200
Message-ID: <20090821140659.GC20935@atrey.karlin.mff.cuni.cz>
References: <20090820163504.131529718@suse.de> <20090820164051.246741046@suse.de> <20090821134207.GA20935@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-ext4@vger.kernel.org
To: npiggin@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34189 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZHUOG6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2009 10:06:58 -0400
Content-Disposition: inline
In-Reply-To: <20090821134207.GA20935@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>   Hi,
> 
> > I also have commented a possible bug in existing ext2 code, marked with XXX.
>   Looks good, except:
> 
> > +int ext2_setsize(struct inode *inode, loff_t newsize)
>   This could be static.
> 
> > @@ -1459,8 +1540,15 @@ int ext2_setattr(struct dentry *dentry,
> >  		if (error)
> >  			return error;
> >  	}
> > -	error = inode_setattr(inode, iattr);
> > +	if (iattr->ia_valid & ATTR_SIZE) {
> > +		error = ext2_setsize(inode, iattr->ia_size);
> > +		if (error)
> > +			return error;
> > +	}
> > +	generic_setattr(inode, iattr);
>   Here, we should store the error code I suppose...
  Ah, I was confused. generic_setattr() returns void. But then remove
the check !error from:
  if (!error && (iattr->ia_valid & ATTR_MODE))
which just follows the generic_setattr(). That's what made me think
generic_setattr() returns something :)

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
