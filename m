From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/3] ext4: basic bug shield for move_extent_per_page
Date: Tue, 28 Aug 2012 20:29:52 +0400
Message-ID: <878vczdlof.fsf@openvz.org>
References: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org> <1346170903-7563-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40510 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2H1Q3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Aug 2012 12:29:55 -0400
Received: by lbbgj3 with SMTP id gj3so3385107lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Aug 2012 09:29:54 -0700 (PDT)
In-Reply-To: <1346170903-7563-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Tue, 28 Aug 2012 20:21:42 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
In order to test MOVE_EXT ioctl code i use run e4defrag and fsstress
in parallel:

--=-=-=
Content-Disposition: inline; filename=285

#! /bin/bash
# FSQA Test No. 270
#
# Online defrag stress test for ext4
#
#-----------------------------------------------------------------------
# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#-----------------------------------------------------------------------
#
# creator
owner=dmonakhov@openvz.org

seq=`basename $0`
echo "QA output created by $seq"

here=`pwd`
tmp=/tmp/$$
status=1	# failure is the default!
trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15

# get standard environment, filters and checks
. ./common.rc
. ./common.filter
. ./common.quota

# Disable all sync operations to get higher load
FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
_workout()
{
	echo ""
	echo "Run fsstress"
	echo ""
	num_iterations=10
	delay=2
	out=$SCRATCH_MNT/fsstress.$$
	# Restrict number of inodes in order to increase  
	setquota -u $qa_user 1000000 1000000 100 100 $SCRATCH_MNT
	args="-p4 -n999999999 -f setattr=0 $FSSTRESS_AVOID -d $out"
	echo "fsstress $args" >> $here/$seq.full
	(su $qa_user -c "$FSSTRESS_PROG $args"  &) > /dev/null 2>&1
	pid=$!
	echo "Run online defrag in parallel"
	for ((i=0; i < num_iterations; i++))
	do
		e4defrag -v $SCRATCH_MNT >> $here/$seq.full 2>&1
		sleep $delay
	done
	killall fsstress
	wait $pid
}

# real QA test starts here
_supported_fs generic
_supported_os Linux
_require_quota
_require_user
_need_to_be_root
_require_scratch

_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
_scratch_mount "-o usrquota,grpquota"
chmod 777 $SCRATCH_MNT
quotacheck -u -g $SCRATCH_MNT 2>/dev/null
quotaon -u -g $SCRATCH_MNT 2>/dev/null

if ! _workout; then
	_scratch_unmount 2>/dev/null
	exit
fi

if ! _check_quota_usage; then
	_scratch_unmount 2>/dev/null
	status=1
	exit
fi

echo Comparing filesystem consistency
if ! _scratch_unmount; then
	echo "failed to umount"
	status=1
	exit
fi
_check_scratch_fs
status=$?
exit

--=-=-=


> The move_extent_per_page function is just one big peace of crap.
> 
> Non-full list of bugs:
> 1) uninitialized extent optimization does not hold page's lock,
>    and simply replace brunches, so writeback code goes
>    crazy because block mapping changed under it's feets
>    kernel BUG at fs/ext4/inode.c:1434!
> 
> 2) uninitialized extent may became initialized right after we
>    drop i_data_sem, so extent state must be rechecked
> 
> 3) Locked pages goes up to date via following sequence:
>    ->readpage(page); lock_page(page); use_that_page(page)
>    But after readpage() one may invalidate it because it is
>    uptodate and unlocked (reclaimer does that)
>    As result kernel bug at include/linux/buffer_head.c:133!
> 4) We call write_begin() with already opened stansaction which
>    result in following deadlock:
> ->move_extent_per_page()
>   ->ext4_journal_start()-> hold journal transaction
>   ->write_begin()
>     ->ext4_da_write_begin()
>       ->ext4_nonda_switch()
>         ->writeback_inodes_sb_if_idle()  --> will wait for journal_stop()
> 
> 5) try_to_release_page() may fail and it does fail if one of page's bh was
>    pinned by journal
> 
> 6) If we about to change page's mapping we MUST hold it's lock during entire
>    remapping procedure, this is true for both pages(original and donor one)
> 
> Fixes:
> 
> - Avoid (1) and (2) simply by temproraly drop uninitialized extent handling
>   optimization, this will be reimplemented later.
> 
> - Fix (3) by manually forcing page to uptodate state w/o dropping it's lock
> 
> - Fix (4) by rearranging existing locking:
>   from: journal_start(); ->write_begin
>   to: write_begin(); journal_extend()
> - Fix (5) simply by checking retvalue
> - (6) requires full function's code rearrangement, will be done later.
> ---
>  fs/ext4/move_extent.c |   74 ++++++++++++++++++++++++-------------------------
>  1 files changed, 36 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index c5826c6..c5ca317 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -812,11 +812,6 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  	 * inode and donor_inode may change each different metadata blocks.
>  	 */
>  	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
> -	handle = ext4_journal_start(orig_inode, jblocks);
> -	if (IS_ERR(handle)) {
> -		*err = PTR_ERR(handle);
> -		return 0;
> -	}
>  
>  	if (segment_eq(get_fs(), KERNEL_DS))
>  		w_flags |= AOP_FLAG_UNINTERRUPTIBLE;
> @@ -824,19 +819,6 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  	orig_blk_offset = orig_page_offset * blocks_per_page +
>  		data_offset_in_page;
>  
> -	/*
> -	 * If orig extent is uninitialized one,
> -	 * it's not necessary force the page into memory
> -	 * and then force it to be written out again.
> -	 * Just swap data blocks between orig and donor.
> -	 */
> -	if (uninit) {
> -		replaced_count = mext_replace_branches(handle, orig_inode,
> -						donor_inode, orig_blk_offset,
> -						block_len_in_page, err);
> -		goto out2;
> -	}
> -
>  	offs = (long long)orig_blk_offset << orig_inode->i_blkbits;
>  
>  	/* Calculate data_size */
> @@ -862,12 +844,28 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  				 &page, &fsdata);
>  	if (unlikely(*err < 0))
>  		goto out;
> +	handle = journal_current_handle();
>  
> +	if (!page_has_buffers(page))
> +		create_empty_buffers(page, 1 << orig_inode->i_blkbits, 0);
> +
> +	/* Force page uptodate similar block_write_commit */
> +	page_zero_new_buffers(page, 0, PAGE_SIZE);
>  	if (!PageUptodate(page)) {
> -		mapping->a_ops->readpage(o_filp, page);
> -		lock_page(page);
> +		struct buffer_head *head, *bh;
> +		bh = head =  page_buffers(page);
> +		do {
> +			if (!bh_uptodate_or_lock(bh)) {
> +				if (bh_submit_read(bh) < 0) {
> +					put_bh(bh);
> +					err2  = -EIO;
> +					goto drop_page;
> +				}
> +			}
> +			bh = bh->b_this_page;
> +		} while (bh != head);
>  	}
> -
> +	SetPageUptodate(page);
>  	/*
>  	 * try_to_release_page() doesn't call releasepage in writeback mode.
>  	 * We should care about the order of writing to the same file
> @@ -876,9 +874,15 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  	 * writeback of the page.
>  	 */
>  	wait_on_page_writeback(page);
> -
> -	/* Release old bh and drop refs */
> -	try_to_release_page(page, 0);
> +	/* Finally page is fully uptodate and locked, it is time to drop
> +	 * old mapping info, function may fail other task hold reference
> +	 * on page's bh */
> +	if (!try_to_release_page(page, 0)) {
> +		replaced_size = 0;
> +		goto write_end;
> +	}
> +	if (ext4_journal_extend(handle, jblocks) < 0)
> +		goto write_end;
>  
>  	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
>  					orig_blk_offset, block_len_in_page,
> @@ -889,7 +893,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  			replaced_size =
>  				block_len_in_page << orig_inode->i_blkbits;
>  		} else
> -			goto out;
> +			goto drop_page;
>  	}
>  
>  	if (!page_has_buffers(page))
> @@ -903,30 +907,24 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
>  		*err = ext4_get_block(orig_inode,
>  				(sector_t)(orig_blk_offset + i), bh, 0);
>  		if (*err < 0)
> -			goto out;
> +			goto drop_page;
>  
>  		if (bh->b_this_page != NULL)
>  			bh = bh->b_this_page;
>  	}
> -
> +write_end:
>  	*err = a_ops->write_end(o_filp, mapping, offs, data_size, replaced_size,
>  			       page, fsdata);
> -	page = NULL;
> -
>  out:
> -	if (unlikely(page)) {
> -		if (PageLocked(page))
> -			unlock_page(page);
> -		page_cache_release(page);
> -		ext4_journal_stop(handle);
> -	}
> -out2:
> -	ext4_journal_stop(handle);
> -
>  	if (err2)
>  		*err = err2;
>  
>  	return replaced_count;
> +drop_page:
> +	unlock_page(page);
> +	page_cache_release(page);
> +	ext4_journal_stop(handle);
> +	goto out;
>  }
>  
>  /**
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
