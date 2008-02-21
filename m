From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use page_mkwrite vma_operations to get mmap
	write notification.
Date: Thu, 21 Feb 2008 09:39:20 -0800
Message-ID: <1203615560.3750.8.camel@localhost.localdomain>
References: <1203392640-14335-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36159 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbYBURkP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 12:40:15 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1LHdUvl000848
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 12:39:30 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1LHdUux240566
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 12:39:30 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1LHdUPr022426
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 12:39:30 -0500
In-Reply-To: <1203392640-14335-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-02-19 at 09:13 +0530, Aneesh Kumar K.V wrote:
> We would like to get notified when we are doing a write on mmap section.
> This is needed with respect to preallocated area. We split the preallocated
> area into initialzed extent and uninitialzed extent in the call back. This
> let us handle ENOSPC better. Otherwise we get ENOSPC in the writepage and
> that would result in data loss. The changes are also needed to handle ENOSPC
> when writing to an mmap section of files with holes.
> 

Hi Aneesh,

I have a concern, it seems we missed journalling the allocation activity
for the mmaped write. See comments below...

Another thing, perhaps similar patch should be ported to ext2/3, as this
also addressed the mmaped write ENOSPC error without
preallocation/deleyed allocation.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/file.c          |   19 ++++++++++++++++++-
>  fs/ext4/inode.c         |    6 ++++++
>  include/linux/ext4_fs.h |    1 +
>  3 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 20507a2..77341c1 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -123,6 +123,23 @@ force_commit:
>  	return ret;
>  }
> 
> +static struct vm_operations_struct ext4_file_vm_ops = {
> +	.fault		= filemap_fault,
> +	.page_mkwrite   = ext4_page_mkwrite,
> +};
> +
> +static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct address_space *mapping = file->f_mapping;
> +
> +	if (!mapping->a_ops->readpage)
> +		return -ENOEXEC;
> +	file_accessed(file);
> +	vma->vm_ops = &ext4_file_vm_ops;
> +	vma->vm_flags |= VM_CAN_NONLINEAR;
> +	return 0;
> +}
> +
>  const struct file_operations ext4_file_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= do_sync_read,
> @@ -133,7 +150,7 @@ const struct file_operations ext4_file_operations = {
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl	= ext4_compat_ioctl,
>  #endif
> -	.mmap		= generic_file_mmap,
> +	.mmap		= ext4_file_mmap,
>  	.open		= generic_file_open,
>  	.release	= ext4_release_file,
>  	.fsync		= ext4_sync_file,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 34f3eb6..81faa67 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3466,3 +3466,9 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
> 
>  	return err;
>  }
> +
> +int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> +{
> +	return block_page_mkwrite(vma, page, ext4_get_block);
> +}
> +

I don't see block allocation being journalled here. block_page_mkwrite()
eventually calling block_prepare_write() which invokes ext4_get_block()
without starting a new journal handle.

Perhaps call ext4 write_begin() and write_end() inode operations, that
would taking care of different write_begin and write_end for three
different journalling mode.

Mingming

> diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
> index 22810b1..8f5a563 100644
> --- a/include/linux/ext4_fs.h
> +++ b/include/linux/ext4_fs.h
> @@ -1059,6 +1059,7 @@ extern void ext4_set_aops(struct inode *inode);
>  extern int ext4_writepage_trans_blocks(struct inode *);
>  extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
>  		struct address_space *mapping, loff_t from);
> +extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
> 
>  /* ioctl.c */
>  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
