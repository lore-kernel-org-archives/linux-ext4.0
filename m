From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 1/8] far: remove i_alloc_sem abuse
Date: Wed, 22 Jun 2011 00:57:43 +0900
Message-ID: <87fwn3mb2g.fsf@devron.myhome.or.jp>
References: <20110620201533.847236272@bombadil.infradead.org>
	<20110620202030.577464178@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110620202030.577464178@bombadil.infradead.org> (Christoph
	Hellwig's message of "Mon, 20 Jun 2011 16:15:34 -0400")
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Add a new rw_semaphore to protect bmap against truncate.  Previous
> i_alloc_sem was abused for this, but it's going away in this series.

In FAT case, ->i_mutex was better. But, last time I saw, shmfs was using
->i_mutex to call ->bmap. So, this was chosen instead.

I'm not checking current version yet though, if shmfs had change, we can
use ->i_mutex.

BTW, this patch looks good to me.

Thanks.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6/fs/fat/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/fat/inode.c	2011-06-20 21:28:19.707963855 +0200
> +++ linux-2.6/fs/fat/inode.c	2011-06-20 21:29:25.031293882 +0200
> @@ -224,9 +224,9 @@ static sector_t _fat_bmap(struct address
>  	sector_t blocknr;
>  
>  	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
> -	down_read(&mapping->host->i_alloc_sem);
> +	down_read(&MSDOS_I(mapping->host)->truncate_lock);
>  	blocknr = generic_block_bmap(mapping, block, fat_get_block);
> -	up_read(&mapping->host->i_alloc_sem);
> +	up_read(&MSDOS_I(mapping->host)->truncate_lock);
>  
>  	return blocknr;
>  }
> @@ -510,6 +510,8 @@ static struct inode *fat_alloc_inode(str
>  	ei = kmem_cache_alloc(fat_inode_cachep, GFP_NOFS);
>  	if (!ei)
>  		return NULL;
> +
> +	init_rwsem(&ei->truncate_lock);
>  	return &ei->vfs_inode;
>  }
>  
> Index: linux-2.6/fs/fat/fat.h
> ===================================================================
> --- linux-2.6.orig/fs/fat/fat.h	2011-06-20 21:28:19.724630522 +0200
> +++ linux-2.6/fs/fat/fat.h	2011-06-20 21:29:25.034627215 +0200
> @@ -109,6 +109,7 @@ struct msdos_inode_info {
>  	int i_attrs;		/* unused attribute bits */
>  	loff_t i_pos;		/* on-disk position of directory entry or 0 */
>  	struct hlist_node i_fat_hash;	/* hash by i_location */
> +	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
>  	struct inode vfs_inode;
>  };
>  
> Index: linux-2.6/fs/fat/file.c
> ===================================================================
> --- linux-2.6.orig/fs/fat/file.c	2011-06-20 21:28:19.744630521 +0200
> +++ linux-2.6/fs/fat/file.c	2011-06-20 21:29:54.501292390 +0200
> @@ -429,8 +429,10 @@ int fat_setattr(struct dentry *dentry, s
>  	}
>  
>  	if (attr->ia_valid & ATTR_SIZE) {
> +		down_write(&MSDOS_I(inode)->truncate_lock);
>  		truncate_setsize(inode, attr->ia_size);
>  		fat_truncate_blocks(inode, attr->ia_size);
> +		up_write(&MSDOS_I(inode)->truncate_lock);
>  	}
>  
>  	setattr_copy(inode, attr);
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
