From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2] ext4: Prevent race while walking extent tree
Date: Wed, 21 Nov 2012 14:55:42 +0800
Message-ID: <20121121065542.GA14704@gmail.com>
References: <1353423460-12178-1-git-send-email-lczerner@redhat.com>
 <1353423460-12178-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dmonakhov@openvz.org,
	bergwolf@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53040 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2KUGnA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2012 01:43:00 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1849536pad.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2012 22:42:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1353423460-12178-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 20, 2012 at 03:57:39PM +0100, Lukas Czerner wrote:
[cut]
> +
>  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		__u64 start, __u64 len)
>  {
> @@ -4802,8 +4811,8 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		 * Walk the extent tree gathering extent information.
>  		 * ext4_ext_fiemap_cb will push extents back to user.
>  		 */

This comment needs to be updated because ext4_ext_fiemap_cb has been
renamed.

Regards,
                                                - Zheng

> -		error = ext4_ext_walk_space(inode, start_blk, len_blks,
> -					  ext4_ext_fiemap_cb, fieinfo);
> +		error = ext4_fill_fiemap_extents(inode, start_blk,
> +						 len_blks, fieinfo);
>  	}
>  
>  	return error;
> -- 
> 1.7.7.6
> 
