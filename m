From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/8] ext4: remove i_alloc_sem abuse
Date: Tue, 21 Jun 2011 18:34:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106211824330.21178@dhcp-27-109.brq.redhat.com>
References: <20110620201533.847236272@bombadil.infradead.org> <20110620202030.765939598@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab1FURHe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 13:07:34 -0400
In-Reply-To: <20110620202030.765939598@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Jun 2011, Christoph Hellwig wrote:

> Add a new rw_semaphore to protect page_mkwrite against truncate.  Previous
> i_alloc_sem was abused for this, but it's going away in this series.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/inode.c	2011-06-20 14:25:33.779248128 +0200
> +++ linux-2.6/fs/ext4/inode.c	2011-06-20 14:27:53.025907745 +0200
> @@ -5357,6 +5357,7 @@ int ext4_setattr(struct dentry *dentry,
>  			if (attr->ia_size > sbi->s_bitmap_maxbytes)
>  				return -EFBIG;
>  		}
> +		down_write(&(EXT4_I(inode)->truncate_lock));
>  	}
>  
>  	if (S_ISREG(inode->i_mode) &&
> @@ -5405,6 +5406,9 @@ int ext4_setattr(struct dentry *dentry,
>  			ext4_truncate(inode);
>  	}
>  
> +	if (attr->ia_valid & ATTR_SIZE)
> +		up_write(&(EXT4_I(inode)->truncate_lock));
> +

Hi Christoph,

this looks like a bug fix, so we should rather do it in a separate
commit. Could you send it separately, or at least mention that in commit
description ?

Otherwise the patch looks good.

Thanks!
-Lukas

>  	if (!rc) {
>  		setattr_copy(inode, attr);
>  		mark_inode_dirty(inode);
> @@ -5850,10 +5854,10 @@ int ext4_page_mkwrite(struct vm_area_str
>  	struct address_space *mapping = inode->i_mapping;
>  
>  	/*
> -	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
> -	 * get i_mutex because we are already holding mmap_sem.
> +	 * Get truncate_lock to stop truncates messing with the inode. We
> +	 * cannot get i_mutex because we are already holding mmap_sem.
>  	 */
> -	down_read(&inode->i_alloc_sem);
> +	down_read(&(EXT4_I(inode)->truncate_lock));
>  	size = i_size_read(inode);
>  	if (page->mapping != mapping || size <= page_offset(page)
>  	    || !PageUptodate(page)) {
> @@ -5865,7 +5869,7 @@ int ext4_page_mkwrite(struct vm_area_str
>  	lock_page(page);
>  	wait_on_page_writeback(page);
>  	if (PageMappedToDisk(page)) {
> -		up_read(&inode->i_alloc_sem);
> +		up_read(&(EXT4_I(inode)->truncate_lock));
>  		return VM_FAULT_LOCKED;
>  	}
>  
> @@ -5883,7 +5887,7 @@ int ext4_page_mkwrite(struct vm_area_str
>  	if (page_has_buffers(page)) {
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
> -			up_read(&inode->i_alloc_sem);
> +			up_read(&(EXT4_I(inode)->truncate_lock));
>  			return VM_FAULT_LOCKED;
>  		}
>  	}
> @@ -5912,11 +5916,11 @@ int ext4_page_mkwrite(struct vm_area_str
>  	 */
>  	lock_page(page);
>  	wait_on_page_writeback(page);
> -	up_read(&inode->i_alloc_sem);
> +	up_read(&(EXT4_I(inode)->truncate_lock));
>  	return VM_FAULT_LOCKED;
>  out_unlock:
>  	if (ret)
>  		ret = VM_FAULT_SIGBUS;
> -	up_read(&inode->i_alloc_sem);
> +	up_read(&(EXT4_I(inode)->truncate_lock));
>  	return ret;
>  }
> Index: linux-2.6/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/super.c	2011-06-20 14:25:33.795914793 +0200
> +++ linux-2.6/fs/ext4/super.c	2011-06-20 14:27:06.269243443 +0200
> @@ -871,6 +871,7 @@ static struct inode *ext4_alloc_inode(st
>  	ei->i_datasync_tid = 0;
>  	atomic_set(&ei->i_ioend_count, 0);
>  	atomic_set(&ei->i_aiodio_unwritten, 0);
> +	init_rwsem(&ei->truncate_lock);
>  
>  	return &ei->vfs_inode;
>  }
> Index: linux-2.6/fs/ext4/ext4.h
> ===================================================================
> --- linux-2.6.orig/fs/ext4/ext4.h	2011-06-20 14:25:33.752581461 +0200
> +++ linux-2.6/fs/ext4/ext4.h	2011-06-20 14:27:06.272576777 +0200
> @@ -844,6 +844,9 @@ struct ext4_inode_info {
>  	/* on-disk additional length */
>  	__u16 i_extra_isize;
>  
> +	/* protect page_mkwrite against truncates */
> +	struct rw_semaphore truncate_lock;
> +
>  #ifdef CONFIG_QUOTA
>  	/* quota space reservation, managed internally by quota code */
>  	qsize_t i_reserved_quota;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
