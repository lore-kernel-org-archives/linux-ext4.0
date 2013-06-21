From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: move bitmaps if shrinking would orphan them
Date: Fri, 21 Jun 2013 09:13:17 -0500
Message-ID: <51C45F7D.1030208@redhat.com>
References: <51C0FA44.3030600@redhat.com> <51C10B41.9020103@redhat.com> <20130621024707.GC10730@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Leonardo Menezes Vaz <lvaz@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422693Ab3FUONU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 10:13:20 -0400
In-Reply-To: <20130621024707.GC10730@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/20/13 9:47 PM, Theodore Ts'o wrote:
> On Tue, Jun 18, 2013 at 08:37:05PM -0500, Eric Sandeen wrote:
>> It is possible to have a flex_bg filesystem with block groups
>> which have inode & block bitmaps at some point well past the
>> start of the group.
>>
>> If an offline shrink puts the new size somewhere between
>> the start of the block group and the (old) location of
>> the bitmaps, they can be left beyond the end of the filesystem,
>> i.e. result in fs corruption.
>>
>> Check each remaining block group for whether its bitmaps
>> are beyond the end of the new filesystem, and reallocate
>> them in a new location if needed.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks good, thanks for the patch.  I made a few minor changes to fix
> up some extra whitespace and a minor optimization.

Great, thanks for the review.

>    	      		       	     - Ted
> 
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 28131c2..204b10a 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -889,7 +889,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
>  	 * bitmaps which are beyond the end of the new filesystem.
>  	 */
>  	new_size = ext2fs_blocks_count(fs->super);
> -	if (ext2fs_blocks_count(fs->super) < ext2fs_blocks_count(old_fs->super)) {
> +	if (new_size < ext2fs_blocks_count(old_fs->super)) {

thanks, I think I *meant* to do that

>  		for (g = 0; g < fs->group_desc_count; g++) {
>  			/*
>  			 * ext2fs_allocate_group_table re-allocates bitmaps
> @@ -900,13 +900,13 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
>  				retval = ext2fs_allocate_group_table(fs, g, 0);
>  				if (retval)
>  					return retval;
> -			} 
                         ^ whoops sorry
> +			}
>  			if (ext2fs_inode_bitmap_loc(fs, g) >= new_size) {
>  				ext2fs_inode_bitmap_loc_set(fs, g, 0);
>  				retval = ext2fs_allocate_group_table(fs, g, 0);
>  				if (retval)
>  					return retval;
> -			}
                         ^ whoops sorry^2!
 
> +			}
>  		}
>  	}
>  
> 

