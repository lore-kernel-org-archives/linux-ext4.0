From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3/xattr_seciruty.c: local functions should be static
Date: Wed, 5 Oct 2011 01:37:46 +0200
Message-ID: <20111004233746.GC21205@quack.suse.cz>
References: <201109231507.09998.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, jack@suse.cz,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933803Ab1JDXhs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 19:37:48 -0400
Content-Disposition: inline
In-Reply-To: <201109231507.09998.hartleys@visionengravers.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 23-09-11 15:07:09, H Hartley Sweeten wrote:
> Quiets the sparse noise:
> 
> warning: symbol 'ext3_initxattrs' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
  Here applies the same comment as to the ext2 patch - not in current
Linus' kernel AFAICS.

								Honza
> 
> ---
> 
> diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
> index 3c218b8..3f065f8 100644
> --- a/fs/ext3/xattr_security.c
> +++ b/fs/ext3/xattr_security.c
> @@ -48,7 +48,7 @@ ext3_xattr_security_set(struct dentry *dentry, const char *name,
>  			      name, value, size, flags);
>  }
>  
> -int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> +static int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  		    void *fs_info)
>  {
>  	const struct xattr *xattr;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
