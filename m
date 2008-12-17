From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which can be used by file systems
Date: Wed, 17 Dec 2008 16:39:40 +0100
Message-ID: <20081217153940.GA6495@atrey.karlin.mff.cuni.cz>
References: <20081212062148.GJ10890@mit.edu> <1229104375-11567-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36466 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYLQPjm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 10:39:42 -0500
Content-Disposition: inline
In-Reply-To: <1229104375-11567-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> 
> Implement blkdev_releasepage() to release the buffer_heads and page
> after we release private data which belongs to a client of the block
> device, such as a filesystem.
> 
> blkdev_releasepage() call the client's releasepage() which is
> registered by blkdev_register_client_releasepage() to release its
> private data.
  Yes, this is IMO the right fix. I'm just wondering about the fact that we
can't block in the client_releasepage(). That seems to be caused by the fact
that we need to be protected against client_releasepage() callback changes
which essentially means umount, right? I'm not saying I have a better solution
but introducing such limitation seems stupid just because of umount...

									Honza

> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/block_dev.c     |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/super.c         |   22 ++++++++++++++++
>  include/linux/fs.h |    9 +++++++
>  3 files changed, 99 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index db831ef..bac0a38 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -29,6 +29,9 @@
>  
>  struct bdev_inode {
>  	struct block_device bdev;
> +	void *client;
> +	int (*client_releasepage)(void*, struct page*, gfp_t);
> +	rwlock_t client_lock;
>  	struct inode vfs_inode;
>  };
>  
> @@ -260,6 +263,9 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
>  	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
>  	if (!ei)
>  		return NULL;
> +	ei->client = NULL;
> +	ei->client_releasepage = NULL;
> +	rwlock_init(&ei->client_lock);
>  	return &ei->vfs_inode;
>  }
>  
> @@ -1208,6 +1214,67 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  	return blkdev_ioctl(bdev, mode, cmd, arg);
>  }
>  
> +/*
> + * blkdev_releasepage: execute ei->client_releasepage() if it exists.
> + * Otherwise, execute try_to_free_buffers().
> + * ei->client_releasepage() releases private client's page if possible.
> + * Because a buffer_head's using counter is bigger than 0 if a client has
> + * a page for private usage. If so, try_to_free_buffers() cannot release it.
> + * Therefore a client must try to release a page itself.
> + */
> +static int blkdev_releasepage(struct page *page, gfp_t wait)
> +{
> +	struct bdev_inode *ei = BDEV_I(page->mapping->host);
> +	int ret;
> +
> +	read_lock(&ei->client_lock);
> +	if (ei->client_releasepage != NULL)
> +		/*
> +		 * Since we are holding a spinlock (ei->client_lock),
> +		 * make sure the client_releasepage function
> +		 * understands that it must not block.
> +		 */
> +		ret = (*ei->client_releasepage)(ei->client, page,
> +						wait & ~__GFP_WAIT);
> +	else
> +		ret = try_to_free_buffers(page);
> +	read_unlock(&ei->client_lock);
> +	return ret;
> +}
> +
> +/*
> + * blkdev_register_client_releasepage: register client_releasepage.
> + */
> +int blkdev_register_client_releasepage(struct block_device *bdev,
> +	void *client, int (*releasepage)(void*, struct page*, gfp_t))
> +{
> +	struct bdev_inode *ei = BDEV_I(bdev->bd_inode);
> +	int ret = 1;
> +
> +	write_lock(&ei->client_lock);
> +	if (ei->client == NULL && ei->client_releasepage == NULL) {
> +		ei->client = client;
> +		ei->client_releasepage = releasepage;
> +	} else if (ei->client != client 
> +			|| ei->client_releasepage != releasepage)
> +		ret = 0;
> +	write_unlock(&ei->client_lock);
> +	return ret;
> +}
> +
> +/*
> + * blkdev_unregister_client_releasepage: unregister client_releasepage.
> + */
> +void blkdev_unregister_client_releasepage(struct block_device *bdev)
> +{
> +	struct bdev_inode *ei = BDEV_I(bdev->bd_inode);
> +
> +	write_lock(&ei->client_lock);
> +	ei->client = NULL;
> +	ei->client_releasepage = NULL;
> +	write_unlock(&ei->client_lock);
> +}
> +
>  static const struct address_space_operations def_blk_aops = {
>  	.readpage	= blkdev_readpage,
>  	.writepage	= blkdev_writepage,
> @@ -1215,6 +1282,7 @@ static const struct address_space_operations def_blk_aops = {
>  	.write_begin	= blkdev_write_begin,
>  	.write_end	= blkdev_write_end,
>  	.writepages	= generic_writepages,
> +	.releasepage	= blkdev_releasepage,
>  	.direct_IO	= blkdev_direct_IO,
>  };
>  
> diff --git a/fs/super.c b/fs/super.c
> index 400a760..fd254eb 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -801,6 +801,18 @@ int get_sb_bdev(struct file_system_type *fs_type,
>  
>  		s->s_flags |= MS_ACTIVE;
>  	}
> +	/*
> +	 * register a client function which releases a page whose mapping is
> +	 * block device 
> +	 */
> +	if (fs_type->release_metadata != NULL
> +		&& !blkdev_register_client_releasepage(bdev, s,
> +			fs_type->release_metadata)) {
> +		up_write(&s->s_umount);
> +		deactivate_super(s);
> +		error = -EBUSY;
> +		goto error_bdev;
> +	}
>  
>  	return simple_set_mnt(mnt, s);
>  
> @@ -819,6 +831,16 @@ void kill_block_super(struct super_block *sb)
>  	struct block_device *bdev = sb->s_bdev;
>  	fmode_t mode = sb->s_mode;
>  
> +	/*
> +	 * unregister a client function which releases a page whose mapping is
> +	 * block device
> +	 *
> +	 * This is sure to be unmounting here, and it releases all own data
> +	 * itself. Therefore the filesystem's function which is owned by the
> +	 * block device, which releases its data is not needed any more.
> +	 */
> +	if (sb->s_type->release_metadata != NULL)
> +		blkdev_unregister_client_releasepage(bdev);
>  	generic_shutdown_super(sb);
>  	sync_blockdev(bdev);
>  	close_bdev_exclusive(bdev, mode);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0dcdd94..398c8ed 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1538,6 +1538,7 @@ struct file_system_type {
>  	int (*get_sb) (struct file_system_type *, int,
>  		       const char *, void *, struct vfsmount *);
>  	void (*kill_sb) (struct super_block *);
> +	int (*release_metadata)(void*, struct page*, gfp_t);
>  	struct module *owner;
>  	struct file_system_type * next;
>  	struct list_head fs_supers;
> @@ -1699,8 +1700,16 @@ extern void bd_set_size(struct block_device *, loff_t size);
>  extern void bd_forget(struct inode *inode);
>  extern void bdput(struct block_device *);
>  extern struct block_device *open_by_devnum(dev_t, fmode_t);
> +extern int blkdev_register_client_releasepage(struct block_device *,
> +	void *, int (*releasepage)(void *, struct page*, gfp_t));
> +extern void blkdev_unregister_client_releasepage(struct block_device *);
>  #else
>  static inline void bd_forget(struct inode *inode) {}
> +static inline int blkdev_register_client_releasepage(struct block_device *,
> +	void *, int (*releasepage)(void *, struct page*, gfp_t))
> +{ return 1; }
> +static inline void blkdev_unregister_client_releasepage(struct block_device *)
> +{}
>  #endif
>  extern const struct file_operations def_blk_fops;
>  extern const struct file_operations def_chr_fops;
> -- 
> 1.6.0.4.8.g36f27.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
