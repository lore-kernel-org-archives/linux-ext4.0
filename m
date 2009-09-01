From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix cache flish in ext4_sync_file
Date: Tue, 01 Sep 2009 13:23:27 -0500
Message-ID: <4A9D669F.1040508@redhat.com>
References: <20090831193553.GA2672@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbZIASX1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 14:23:27 -0400
In-Reply-To: <20090831193553.GA2672@lst.de>
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

Fixing my old commit, I guess ;)

Seems right to me

Acked-by: Eric Sandeen <sandeen@redhat.com>


> Index: linux-2.6/fs/ext4/fsync.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/fsync.c
> +++ linux-2.6/fs/ext4/fsync.c
> @@ -92,9 +92,9 @@ int ext4_sync_file(struct file *file, st
>  			.nr_to_write = 0, /* sys_fsync did this */
>  		};
>  		ret = sync_inode(inode, &wbc);
> -		if (journal && (journal->j_flags & JBD2_BARRIER))
> -			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>  	}
>  out:
> +	if (journal && (journal->j_flags & JBD2_BARRIER))
> +		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

