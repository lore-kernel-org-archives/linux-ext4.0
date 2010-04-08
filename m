From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Wed, 07 Apr 2010 23:47:23 -0500
Message-ID: <4BBD5FDB.9010100@redhat.com>
References: <4BBD285B.9000603@gmail.com> <4BBD2FDF.4040407@redhat.com> <4BBD3365.90306@gmail.com> <4BBD5740.4070101@redhat.com> <4BBD5D90.4090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0DHErj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 00:47:39 -0400
In-Reply-To: <4BBD5D90.4090203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> I'll have to think about the right way to do this... it seems pretty
>> convoluted to me right now.
>>   
> Something like this probably works, but I really REALLY would not test
> it on an important filesystem.   :)
> 
> I'm not sure it's a good idea to discard it before returning it
> to the prealloc pool, because it may well get re-used again
> quickly.... not sure if that's helpful.

(now I'm really talking to myself, but scratch that bit - 
ext4_mb_return_to_preallocation is pretty much a no-op)

-Eric

> Just a note, I think eventually we may move to more of a batch discard
> in the background, because these little discards are actually quite
> inefficient on the hardware we've tested so far.
> 
> -Eric
> 
> p.s. really.  Don't test this with important data.  I haven't tested
> it at all yet.
> 
> Index: linux-2.6/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/mballoc.c
> +++ linux-2.6/fs/ext4/mballoc.c
> @@ -4602,6 +4606,8 @@ do_more:
>  		mb_clear_bits(bitmap_bh->b_data, bit, count);
>  		ext4_mb_free_metadata(handle, &e4b, new_entry);
>  	} else {
> +		ext4_fsblk_t discard_block;
> +
>  		/* need to update group_info->bb_free and bitmap
>  		 * with group lock held. generate_buddy look at
>  		 * them with group lock_held
> @@ -4609,6 +4615,11 @@ do_more:
>  		ext4_lock_group(sb, block_group);
>  		mb_clear_bits(bitmap_bh->b_data, bit, count);
>  		mb_free_blocks(inode, &e4b, bit, count);
> +		discard_block = bit +
> +				ext4_group_first_block_no(sb, block_group);
> +		trace_ext4_discard_blocks(sb,
> +				(unsigned long long)discard_block, count);
> +		sb_issue_discard(sb, discard_block, count);
>  		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

