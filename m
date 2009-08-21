From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 06/11] ext2: convert to use the new truncate convention.
Date: Fri, 21 Aug 2009 15:42:07 +0200
Message-ID: <20090821134207.GA20935@atrey.karlin.mff.cuni.cz>
References: <20090820163504.131529718@suse.de> <20090820164051.246741046@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-ext4@vger.kernel.org
To: npiggin@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48682 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbZHUNmG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2009 09:42:06 -0400
Content-Disposition: inline
In-Reply-To: <20090820164051.246741046@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I also have commented a possible bug in existing ext2 code, marked with XXX.
  Looks good, except:

> +int ext2_setsize(struct inode *inode, loff_t newsize)
  This could be static.

> @@ -1459,8 +1540,15 @@ int ext2_setattr(struct dentry *dentry,
>  		if (error)
>  			return error;
>  	}
> -	error = inode_setattr(inode, iattr);
> +	if (iattr->ia_valid & ATTR_SIZE) {
> +		error = ext2_setsize(inode, iattr->ia_size);
> +		if (error)
> +			return error;
> +	}
> +	generic_setattr(inode, iattr);
  Here, we should store the error code I suppose...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
