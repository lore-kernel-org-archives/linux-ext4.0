From: Nick Piggin <npiggin@suse.de>
Subject: [patch] ext2: convert to use the new truncate convention fix
Date: Mon, 24 Aug 2009 07:30:06 +0200
Message-ID: <20090824053006.GP25721@wotan.suse.de>
References: <20090820163504.131529718@suse.de> <20090820164051.246741046@suse.de> <20090821134207.GA20935@atrey.karlin.mff.cuni.cz> <20090821140659.GC20935@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZHXFaF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 01:30:05 -0400
Content-Disposition: inline
In-Reply-To: <20090821140659.GC20935@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 21, 2009 at 04:06:59PM +0200, Jan Kara wrote:
> >   Hi,
> > 
> > > I also have commented a possible bug in existing ext2 code, marked with XXX.
> >   Looks good, except:
> > 
> > > +int ext2_setsize(struct inode *inode, loff_t newsize)
> >   This could be static.
> > 
> > > @@ -1459,8 +1540,15 @@ int ext2_setattr(struct dentry *dentry,
> > >  		if (error)
> > >  			return error;
> > >  	}
> > > -	error = inode_setattr(inode, iattr);
> > > +	if (iattr->ia_valid & ATTR_SIZE) {
> > > +		error = ext2_setsize(inode, iattr->ia_size);
> > > +		if (error)
> > > +			return error;
> > > +	}
> > > +	generic_setattr(inode, iattr);
> >   Here, we should store the error code I suppose...
>   Ah, I was confused. generic_setattr() returns void. But then remove
> the check !error from:
>   if (!error && (iattr->ia_valid & ATTR_MODE))
> which just follows the generic_setattr(). That's what made me think
> generic_setattr() returns something :)

Yep, good suggestion. Andrew please add this incremental patch

---
 fs/ext2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c
+++ linux-2.6/fs/ext2/inode.c
@@ -1546,7 +1546,7 @@ int ext2_setattr(struct dentry *dentry,
 			return error;
 	}
 	generic_setattr(inode, iattr);
-	if (!error && (iattr->ia_valid & ATTR_MODE))
+	if (iattr->ia_valid & ATTR_MODE)
 		error = ext2_acl_chmod(inode);
 	mark_inode_dirty(inode);
 
