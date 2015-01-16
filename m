From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: + ext4-add-dax-functionality.patch added to -mm tree
Date: Fri, 16 Jan 2015 21:16:03 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
 <20150115124106.GF12739@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"boaz@plexistor.com" <boaz@plexistor.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@lst.de" <hch@lst.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64484 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbbAPVQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jan 2015 16:16:06 -0500
In-Reply-To: <20150115124106.GF12739@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----Original Message-----
From: Jan Kara [mailto:jack@suse.cz] 
Sent: Thursday, January 15, 2015 4:41 AM
To: ross.zwisler@linux.intel.com
Cc: akpm@linux-foundation.org; Dilger, Andreas; axboe@kernel.dk; boaz@plexistor.com; david@fromorbit.com; hch@lst.de; jack@suse.cz; kirill.shutemov@linux.intel.com; mathieu.desnoyers@efficios.com; Wilcox, Matthew R; rdunlap@infradead.org; tytso@mit.edu; mm-commits@vger.kernel.org; linux-ext4@vger.kernel.org
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree

On Mon 12-01-15 15:11:17, Andrew Morton wrote:
> +#ifdef CONFIG_FS_DAX
> +static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	return dax_fault(vma, vmf, ext4_get_block);
> +					/* Is this the right get_block? */
  You can remove the comment. It is the right get_block function.

Are you sure it shouldn't be ext4_get_block_write, or _write_nolock?  According to the comments, ext4_get_block() doesn't allocate uninitialized extents, which we do want it to do.

> diff -puN fs/ext4/inode.c~ext4-add-dax-functionality fs/ext4/inode.c
> --- a/fs/ext4/inode.c~ext4-add-dax-functionality
> +++ a/fs/ext4/inode.c
> @@ -657,6 +657,18 @@ has_zeroout:
>  	return retval;
>  }
>  
> +static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
> +{
> +	struct inode *inode = bh->b_assoc_map->host;
> +	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
  That should be 16 TB if I'm doing the math right - 32-bit block number *
block size (4k) = 16 TB. And that's the max limit of ext4 (as logical file
offset in blocks has to fit in 32-bits for ext4). So I think you can just
remove the comment. But also see comment below.

Blargh, yes, you're right.

> @@ -694,6 +706,11 @@ static int _ext4_get_block(struct inode
>  
>  		map_bh(bh, inode->i_sb, map.m_pblk);
>  		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
> +		if (IS_DAX(inode) && buffer_unwritten(bh) && !io_end) {
> +			bh->b_assoc_map = inode->i_mapping;
> +			bh->b_private = (void *)(unsigned long)iblock;
> +			bh->b_end_io = ext4_end_io_unwritten;
> +		}
  So why is this needed? It would deserve a comment. It confuses me in
particular because:
1) This is a often a phony bh used just as a container for passed data and
   b_end_io is just ignored.
2) Even if it was real bh attached to a page, for DAX we don't do any
   writeback and thus ->b_end_io will never get called?
3) And if it does get called, you certainly cannot call
   ext4_convert_unwritten_extents() from softirq context where ->b_end_io
   gets called.

This got added to fix a problem that Dave Chinner pointed out.  We need the allocated extent to either be zeroed (as ext2 does), or marked as unwritten (ext4, XFS) so that a racing read/page fault doesn't return uninitialized data.  If it's marked as unwritten, we need to convert it to a written extent after we've initialised the contents.  We use the b_end_io() callback to do this, and it's called from the DAX code, not in softirq context.

>  		if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN)
>  			set_buffer_defer_completion(bh);
>  		bh->b_size = inode->i_sb->s_blocksize * map.m_len;

								Honza
