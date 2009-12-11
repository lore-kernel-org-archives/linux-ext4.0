From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Fri, 11 Dec 2009 16:27:27 -0700
Message-ID: <71F621CE-B943-4ACC-90E9-6D03A8D2C3A6@sun.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
 <8352E6B3-4561-40D7-AEC0-A4119A685F46@sun.com>
 <6601abe90912111401t2749bc1en3d8e5b8f81787897@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36983 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471AbZLKX1Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2009 18:27:24 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nBBNRSR3023537
	for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2009 15:27:31 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KUI00200H2R0600@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 11 Dec 2009 15:27:28 -0800 (PST)
In-reply-to: <6601abe90912111401t2749bc1en3d8e5b8f81787897@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-12-11, at 15:01, Curt Wohlgemuth wrote:
> Andreas Dilger wrote:
>> IIRC, during the discussion of this problem, Ted pointed out that  
>> this can
>> only happen if the filesystem is running in no-journal mode.   
>> Otherwise,
>> there are shadow allocation bitmaps that prevent metadata blocks  
>> from being
>> reallocated until the transaction that released them has committed.
>>
>> In that case, it makes sense to only do this extra work if the  
>> filesystem is
>> running in no-journal mode.
>
> Good point, Andreas.  I changed this to send in the handle to
> ext4_ext_zeroout().

I was just thinking of checking EXT4_SB(inode->i_sb)->s_journal ==  
NULL.  I also thought about checking EXT4_HAS_INCOMPAT_FEATURE(sb,  
NEEDS_RECOVERY), but I don't know if that is 100% safe (i.e. is it  
possible to mount such a filesystem with "norecovery"?).

I don't have any particular objection to this patch, though it gives  
the slightly false impression that the blocks being zeroed are  
journaled, and it needs to modify a lot more places in the code.

> =========================================
>
> This fixes a bug with no journal being used, in which new blocks  
> returned
> from an extent created with ext4_ext_zeroout() can have dirty  
> metadata still
> associated with them.
>
> 	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
>
> This is for the problem I reported on 23 Nov ("Bug in extent  
> zeroout: blocks
> not marked as new").  I'm not seeing the corruption with this fix  
> that I was
> seeing without it.
>
> diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
> --- orig/fs/ext4/extents.c	2009-12-09 15:09:25.000000000 -0800
> +++ new/fs/ext4/extents.c	2009-12-11 13:56:11.000000000 -0800
> @@ -2421,7 +2421,8 @@ static void bi_complete(struct bio *bio,
> }
>
> /* FIXME!! we need to try to merge to left or right after zero-out  */
> -static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent  
> *ex)
> +static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent  
> *ex,
> +				handle_t *handle)
> {
> 	int ret = -EIO;
> 	struct bio *bio;
> @@ -2474,9 +2475,28 @@ static int ext4_ext_zeroout(struct inode
> 		submit_bio(WRITE, bio);
> 		wait_for_completion(&event);
>
> -		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> +		if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
> +
> 			ret = 0;
> -		else {
> +
> +			/* On success, if there is no journal through which
> +			 * metadata is committed, we need to insure all
> +			 * metadata associated with each of these blocks is
> +			 * unmapped. */
> +			if (!ext4_handle_valid(handle)) {
> +				sector_t block = ee_pblock;
> +
> +				done = 0;
> +				while (done < len) {
> +					unmap_underlying_metadata(inode->i_sb->
> +							                s_bdev,
> +								  block);
> +
> +					done++;
> +					block++;
> +				}
> +			}
> +		} else {
> 			ret = -EIO;
> 			break;
> 		}
> @@ -2532,7 +2552,7 @@ static int ext4_ext_convert_to_initializ
> 		goto out;
> 	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
> 	if (ee_len <= 2*EXT4_EXT_ZERO_LEN) {
> -		err =  ext4_ext_zeroout(inode, &orig_ex);
> +		err =  ext4_ext_zeroout(inode, &orig_ex, handle);
> 		if (err)
> 			goto fix_extent_len;
> 		/* update the extent length and mark as initialized */
> @@ -2583,7 +2603,8 @@ static int ext4_ext_convert_to_initializ
> 			err = ext4_ext_insert_extent(handle, inode, path,
> 							ex3, 0);
> 			if (err == -ENOSPC) {
> -				err =  ext4_ext_zeroout(inode, &orig_ex);
> +				err =  ext4_ext_zeroout(inode, &orig_ex,
> +							handle);
> 				if (err)
> 					goto fix_extent_len;
> 				ex->ee_block = orig_ex.ee_block;
> @@ -2603,7 +2624,7 @@ static int ext4_ext_convert_to_initializ
> 			 * implies that we can leak some junk data to user
> 			 * space.
> 			 */
> -			err =  ext4_ext_zeroout(inode, ex3);
> +			err =  ext4_ext_zeroout(inode, ex3, handle);
> 			if (err) {
> 				/*
> 				 * We should actually mark the
> @@ -2639,7 +2660,7 @@ static int ext4_ext_convert_to_initializ
> 		ext4_ext_mark_uninitialized(ex3);
> 		err = ext4_ext_insert_extent(handle, inode, path, ex3, 0);
> 		if (err == -ENOSPC) {
> -			err =  ext4_ext_zeroout(inode, &orig_ex);
> +			err =  ext4_ext_zeroout(inode, &orig_ex, handle);
> 			if (err)
> 				goto fix_extent_len;
> 			/* update the extent length and mark as initialized */
> @@ -2688,7 +2709,7 @@ static int ext4_ext_convert_to_initializ
> 		 */
> 		if (le16_to_cpu(orig_ex.ee_len) <= EXT4_EXT_ZERO_LEN &&
> 							iblock != ee_block) {
> -			err =  ext4_ext_zeroout(inode, &orig_ex);
> +			err =  ext4_ext_zeroout(inode, &orig_ex, handle);
> 			if (err)
> 				goto fix_extent_len;
> 			/* update the extent length and mark as initialized */
> @@ -2757,7 +2778,7 @@ static int ext4_ext_convert_to_initializ
> insert:
> 	err = ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> 	if (err == -ENOSPC) {
> -		err =  ext4_ext_zeroout(inode, &orig_ex);
> +		err =  ext4_ext_zeroout(inode, &orig_ex, handle);
> 		if (err)
> 			goto fix_extent_len;
> 		/* update the extent length and mark as initialized */
> @@ -2871,7 +2892,7 @@ static int ext4_split_unwritten_extents(
> 		ext4_ext_mark_uninitialized(ex3);
> 		err = ext4_ext_insert_extent(handle, inode, path, ex3, flags);
> 		if (err == -ENOSPC) {
> -			err =  ext4_ext_zeroout(inode, &orig_ex);
> +			err =  ext4_ext_zeroout(inode, &orig_ex, handle);
> 			if (err)
> 				goto fix_extent_len;
> 			/* update the extent length and mark as initialized */
> @@ -2942,7 +2963,7 @@ static int ext4_split_unwritten_extents(
> insert:
> 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> 	if (err == -ENOSPC) {
> -		err =  ext4_ext_zeroout(inode, &orig_ex);
> +		err =  ext4_ext_zeroout(inode, &orig_ex, handle);
> 		if (err)
> 			goto fix_extent_len;
> 		/* update the extent length and mark as initialized */
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

