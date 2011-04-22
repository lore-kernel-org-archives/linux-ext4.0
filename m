From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Sat, 23 Apr 2011 00:10:25 +0200
Message-ID: <20110422221025.GF2977@quack.suse.cz>
References: <4D9BF57A.6030705@jp.fujitsu.com>
 <20110406055708.GB23285@quack.suse.cz>
 <4D9C18DF.90803@jp.fujitsu.com>
 <20110406174617.GC28689@quack.suse.cz>
 <4DA84A7B.3040403@jp.fujitsu.com>
 <20110415171310.GB5432@quack.suse.cz>
 <4DABFEBD.7030102@jp.fujitsu.com>
 <20110418105105.GB5557@quack.suse.cz>
 <4DAD5934.1030901@jp.fujitsu.com>
 <20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709Ab1DVWK2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Apr 2011 18:10:28 -0400
Content-Disposition: inline
In-Reply-To: <20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 22-04-11 15:58:39, Toshiyuki Okajima wrote:
> I have confirmed that the following patch works fine while my or
> Mizuma-san's reproducer is running. Therefore,
>  we can block to write the data, which is mmapped to a file, into a disk
> by a page-fault while fsfreezing. 
> 
> I think this patch fixes the following two problems:
> - A deadlock occurs between ext4_da_writepages() (called from
> writeback_inodes_wb) and thaw_super(). (reported by Mizuma-san)
> - We can also write the data, which is mmapped to a file,
>   into a disk while fsfreezing (ext3/ext4).
>                                        (reported by me)
> 
> Please examine this patch.
  Thanks for the patch. The ext3 part is not as easy as this. You cannot
really get i_alloc_sem in ext3_page_mkwrite() because mmap_sem is already
held by page fault code and i_alloc_sem should be acquired before it (yes I
know, ext4 already has this bug which should be fixed when I get to it).
Also you'll find that performance of random writers via mmap (which is
relatively common) is going to be rather bad with this patch (because the
file will be heavily fragmented). We have to be more clever which is
exactly why it's taking me so long with my patch :) But tests are already
running so if everything goes fine, I should have patches to submit next
week.

The ext4 part looks correct. I'd just also like to have some comments about
how freeze handling is done because it's kind of subtle.

								Honza

> diff --git a/fs/ext3/file.c b/fs/ext3/file.c
> index f55df0e..6d376ef 100644
> --- a/fs/ext3/file.c
> +++ b/fs/ext3/file.c
> @@ -52,6 +52,23 @@ static int ext3_release_file (struct inode * inode, struct file * filp)
>  	return 0;
>  }
>  
> +static const struct vm_operations_struct ext3_file_vm_ops = {
> +	.fault          = filemap_fault,
> +	.page_mkwrite   = ext3_page_mkwrite,
> +};
> +
> +static int ext3_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct address_space *mapping = file->f_mapping;
> +
> +	if (!mapping->a_ops->readpage)
> +		return -ENOEXEC;
> +	file_accessed(file);
> +	vma->vm_ops = &ext3_file_vm_ops;
> +	vma->vm_flags |= VM_CAN_NONLINEAR;
> +	return 0;
> +}
> +
>  const struct file_operations ext3_file_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= do_sync_read,
> @@ -62,7 +79,7 @@ const struct file_operations ext3_file_operations = {
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl	= ext3_compat_ioctl,
>  #endif
> -	.mmap		= generic_file_mmap,
> +	.mmap		= ext3_file_mmap,
>  	.open		= dquot_file_open,
>  	.release	= ext3_release_file,
>  	.fsync		= ext3_sync_file,
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 68b2e43..66c31dd 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -3496,3 +3496,74 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
>  
>  	return err;
>  }
> +
> +int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	struct page *page = vmf->page;
> +	loff_t size;
> +	unsigned long len;
> +	int ret = -EINVAL;
> +	void *fsdata;
> +	struct file *file = vma->vm_file;
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct address_space *mapping = inode->i_mapping;
> +
> +	/*
> +	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
> +	 * get i_mutex because we are already holding mmap_sem.
> +	 */
> +	down_read(&inode->i_alloc_sem);
> +	size = i_size_read(inode);
> +	if (page->mapping != mapping || size <= page_offset(page)
> +	   || !PageUptodate(page)) {
> +		/* page got truncated from under us? */
> +		goto out_unlock;
> +	}
> +	ret = 0;
> +	if (PageMappedToDisk(page))
> +		goto out_frozen;
> +
> +	if (page->index == size >> PAGE_CACHE_SHIFT)
> +		len = size & ~PAGE_CACHE_MASK;
> +	else
> +		len = PAGE_CACHE_SIZE;
> +
> +	lock_page(page);
> +	/*
> +	 * return if we have all the buffers mapped. This avoid
> +	 * the need to call write_begin/write_end which does a
> +	 * journal_start/journal_stop which can block and take
> +	 * long time
> +	 */
> +	if (page_has_buffers(page)) {
> +		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> +					buffer_unmapped)) {
> +			unlock_page(page);
> +out_frozen:
> +			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> +			goto out_unlock;
> +		}
> +	}
> +	unlock_page(page);
> +	/*
> +	 * OK, we need to fill the hole... Do write_begin write_end
> +	 * to do block allocation/reservation.We are not holding
> +	 * inode.i__mutex here. That allow * parallel write_begin,
> +	 * write_end call. lock_page prevent this from happening
> +	 * on the same page though
> +	 */
> +	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
> +			len, AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
> +			len, len, page, fsdata);
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = 0;
> +out_unlock:
> +	if (ret)
> +		ret = VM_FAULT_SIGBUS;
> +	up_read(&inode->i_alloc_sem);
> +	return ret;
> +}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f2fa5e8..44979ae 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5812,7 +5812,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	}
>  	ret = 0;
>  	if (PageMappedToDisk(page))
> -		goto out_unlock;
> +		goto out_frozen;
>  
>  	if (page->index == size >> PAGE_CACHE_SHIFT)
>  		len = size & ~PAGE_CACHE_MASK;
> @@ -5830,6 +5830,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
>  			unlock_page(page);
> +out_frozen:
> +			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
>  			goto out_unlock;
>  		}
>  	}
> diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> index 85c1d30..a0e39ca 100644
> --- a/include/linux/ext3_fs.h
> +++ b/include/linux/ext3_fs.h
> @@ -919,6 +919,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
>  extern void ext3_set_aops(struct inode *inode);
>  extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		       u64 start, u64 len);
> +extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
>  
>  /* ioctl.c */
>  extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
> -- 
> 1.5.5.6
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
