From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: enable cache flush in ext3_sync_file
Date: Tue, 01 Sep 2009 13:24:05 -0500
Message-ID: <4A9D66C5.4060806@redhat.com>
References: <20090831193712.GB2672@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbZIASYF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 14:24:05 -0400
In-Reply-To: <20090831193712.GB2672@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> We need to flush the write cache unconditionally in ->fsync, otherwise
> writes into already allocated blocks can get lost.  Writes into fully
> allocated files are very common when using disk images for
> virtualization, and without this fix can easily lose data after
> an fdatasync, which is the typical implementation for a cache flush on
> the virtual drive.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Given that I tried to do the same thing 1.5 years ago (though not quite
correctly) ...

Acked-by: Eric Sandeen <sandeen@redhat.com>

> 
> Index: linux-2.6/fs/ext3/fsync.c
> ===================================================================
> --- linux-2.6.orig/fs/ext3/fsync.c
> +++ linux-2.6/fs/ext3/fsync.c
> @@ -23,6 +23,7 @@
>   */
>  
>  #include <linux/time.h>
> +#include <linux/blkdev.h>
>  #include <linux/fs.h>
>  #include <linux/sched.h>
>  #include <linux/writeback.h>
> @@ -87,5 +88,7 @@ int ext3_sync_file(struct file * file, s
>  		ret = sync_inode(inode, &wbc);
>  	}
>  out:
> +	if (test_opt(inode->i_sb, BARRIER))
> +		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

