From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2/xattr_security.c: local functions should be static
Date: Wed, 5 Oct 2011 01:37:04 +0200
Message-ID: <20111004233704.GB21205@quack.suse.cz>
References: <201109231351.24566.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, jack@suse.cz
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab1JDXhF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 19:37:05 -0400
Content-Disposition: inline
In-Reply-To: <201109231351.24566.hartleys@visionengravers.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 23-09-11 13:51:24, H Hartley Sweeten wrote:
> This quiets the sparse noise:
> 
> warning: symbol 'ext2_initxattrs' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jan Kara <jack@suse.cz>
  Hmm, this patch doesn't seem to be against latest Linus kernel... At
least I don't see ext2_initxattrs() there - although I remember seeing
patches adding this function flying somewhere.

								Honza

> diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
> index c922adc..ed1a5d5 100644
> --- a/fs/ext2/xattr_security.c
> +++ b/fs/ext2/xattr_security.c
> @@ -46,7 +46,7 @@ ext2_xattr_security_set(struct dentry *dentry, const char *name,
>  			      value, size, flags);
>  }
>  
> -int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> +static int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  		    void *fs_info)
>  {
>  	const struct xattr *xattr;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
