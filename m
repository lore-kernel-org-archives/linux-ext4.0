From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support features in larger inode
Date: Mon, 16 Jul 2007 18:06:33 -0600
Message-ID: <20070717000633.GX5992@schatzie.adilger.int>
References: <1183275482.4010.133.camel@localhost.localdomain> <20070710163247.5c8bfa3f.akpm@linux-foundation.org> <20070713020529.1486491f.akpm@linux-foundation.org> <1184629924.3836.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:33761 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbXGQAGg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jul 2007 20:06:36 -0400
Content-Disposition: inline
In-Reply-To: <1184629924.3836.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 16, 2007  16:52 -0700, Mingming Cao wrote:
> I am not sure why we need GFP_KERNEL flag here. I think we should use
> GFP_NOFS instead. The following patch use the GFP_NOFS flag, as well as
> fixing memory leak issue introduced by the ext4 expand inode extra isize
> patch.
> 
> Fixing memory allocation issue with expand inode extra isize patch.
> 
> - use GFP_NOFS instead of GFP_KERNEL flag for memory allocation
> - use kzalloc instead of kmalloc

This doesn't need kzalloc() for buffer and b_entry_name, since they are
immediately overwritten by memcpy().

> - fix memory leak in the success case, at the end of while loop.
>  			goto cleanup;
> @@ -1302,7 +1302,15 @@ retry:
>  		error = ext4_xattr_block_set(handle, inode, &i, bs);
>  		if (error)
>  			goto cleanup;
> +		kfree(b_entry_name);
> +		kfree(buffer);
> +		brelse(is->iloc.bh);
> +		kfree(is);
> +		kfree(bs);
> +		brelse(bh);
>  	}
> +	up_write(&EXT4_I(inode)->xattr_sem);
> +        return 0;
>  
>  cleanup:
>  	kfree(b_entry_name);

I don't think you should have brelse(bh) inside the loop, since it is
allocated before the loop starts.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
