From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH -v2] ext4: Switch to non delalloc mode when we are
	low on free blocks count.
Date: Mon, 25 Aug 2008 14:31:14 -0700
Message-ID: <1219699874.6394.32.camel@mingming-laptop>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219663233-21849-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219663233-21849-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44400 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYHYVbj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2008 17:31:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7PLY0Sp021524
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 17:34:00 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PLVF3c236478
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 17:31:16 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7PLVFSx003275
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 17:31:15 -0400
In-Reply-To: <1219663233-21849-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-25=E4=B8=80=E7=9A=84 16:50 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> delayed allocation allocate blocks during writepages. That also
> means we cannot handle block allocation failures. Switch to
> non - delalloc when we are running low on free blocks.
> Delayed allocation need to do aggressive meta-data block reservation
> considering that the requested blocks can all be discontiguous.
> Switching to non-delalloc avoids that. Also we can satisfy
> partial write in non-delalloc mode.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   48 +++++++++++++++++++++++++++++++++++++++++++++=
+--
>  1 files changed, 46 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3f3ecc0..d923a14 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2482,6 +2482,29 @@ static int ext4_da_writepages(struct address_s=
pace *mapping,
>  	return ret;
>  }
>=20
> +#define FALL_BACK_TO_NONDELALLOC 1
> +static int ext4_nonda_switch(struct super_block *sb)
> +{
> +	s64 free_blocks, dirty_blocks;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +
> +	/*
> +	 * switch to non delalloc mode if we are running low
> +	 * on free block. The free block accounting via percpu
> +	 * counters can get slightly wrong with FBC_BATCH getting
> +	 * accumulated on each CPU without updating global counters
> +	 * Delalloc need an accurate free block accounting. So switch
> +	 * to non delalloc when we are near to error range.
> +	 */
> +	free_blocks  =3D percpu_counter_read_positive(&sbi->s_freeblocks_co=
unter);
> +	dirty_blocks =3D percpu_counter_read_positive(&sbi->s_dirtyblocks_c=
ounter);
> +	if ( 2 * free_blocks < 3 * dirty_blocks) {
> +		/* free block count is less that 150% of dirty blocks */
> +		return 1;
> +	}

In the case the free_blocks is below the EXT4_FREEBLOCKS_WATERMARK, we
should turn back to nondelalloc mode, even if there is no dirty_blocks.

> +	return 0;
> +}
> +
>  static int ext4_da_write_begin(struct file *file, struct address_spa=
ce *mapping,
>  				loff_t pos, unsigned len, unsigned flags,
>  				struct page **pagep, void **fsdata)
> @@ -2496,6 +2519,13 @@ static int ext4_da_write_begin(struct file *fi=
le, struct address_space *mapping,
>  	index =3D pos >> PAGE_CACHE_SHIFT;
>  	from =3D pos & (PAGE_CACHE_SIZE - 1);
>  	to =3D from + len;
> +
> +	if (ext4_nonda_switch(inode->i_sb)) {
> +		*fsdata =3D (void *)FALL_BACK_TO_NONDELALLOC;
> +		return ext4_write_begin(file, mapping, pos,
> +					len, flags, pagep, fsdata);
> +	}
> +	*fsdata =3D (void *)0;

We probably should add a warning if *fsdata is non 0, instead of forcin=
g
it reset to 0 unconditionally.

>  retry:
>  	/*
>  	 * With delayed allocation, we don't log the i_disksize update
> @@ -2564,6 +2594,19 @@ static int ext4_da_write_end(struct file *file=
,
>  	handle_t *handle =3D ext4_journal_current_handle();
>  	loff_t new_i_size;
>  	unsigned long start, end;
> +	int write_mode =3D (int)fsdata;
> +
> +	if (write_mode =3D=3D FALL_BACK_TO_NONDELALLOC) {
> +		if (ext4_should_order_data(inode)) {
> +			return ext4_ordered_write_end(file, mapping, pos,
> +					len, copied, page, fsdata);
> +		} else if (ext4_should_writeback_data(inode)) {
> +			return ext4_writeback_write_end(file, mapping, pos,
> +					len, copied, page, fsdata);
> +		} else {
> +			BUG();

Shouldn't we warnining user that we can't fall back to journalled mode
instead, let it continue with delalloc mode, instead of BUG() the
system?

> +		}
> +	}
>=20
>  	start =3D pos & (PAGE_CACHE_SIZE - 1);
>  	end =3D start + copied -1;
> @@ -4901,6 +4944,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vm=
a, struct page *page)
>  	loff_t size;
>  	unsigned long len;
>  	int ret =3D -EINVAL;
> +	void *fsdata;
>  	struct file *file =3D vma->vm_file;
>  	struct inode *inode =3D file->f_path.dentry->d_inode;
>  	struct address_space *mapping =3D inode->i_mapping;
> @@ -4939,11 +4983,11 @@ int ext4_page_mkwrite(struct vm_area_struct *=
vma, struct page *page)
>  	 * on the same page though
>  	 */
>  	ret =3D mapping->a_ops->write_begin(file, mapping, page_offset(page=
),
> -			len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
> +			len, AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
>  	if (ret < 0)
>  		goto out_unlock;
>  	ret =3D mapping->a_ops->write_end(file, mapping, page_offset(page),
> -			len, len, page, NULL);
> +			len, len, page, fsdata);
>  	if (ret < 0)
>  		goto out_unlock;
>  	ret =3D 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
