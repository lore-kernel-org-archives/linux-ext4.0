From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/2] fs/ext4: mb_find_order_for_block(): silence UBSAN
Date: Thu, 5 May 2016 17:58:19 -0400
Message-ID: <20160505215819.GA30122@thunk.org>
References: <1458421925-5481-1-git-send-email-nicstange@gmail.com>
 <1458421925-5481-2-git-send-email-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51602 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbcEEV6W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 17:58:22 -0400
Content-Disposition: inline
In-Reply-To: <1458421925-5481-2-git-send-email-nicstange@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 19, 2016 at 10:12:04PM +0100, Nicolai Stange wrote:
> Currently, in mb_find_order_for_block(), there's a loop like the following:
> 
>   while (order <= e4b->bd_blkbits + 1) {
>     ...
>     bb += 1 << (e4b->bd_blkbits - order);
>   }
> 
> Note that the updated bb is used in the loop's next iteration only.
> 
> However, at the last iteration, that is at order == e4b->bd_blkbits + 1,
> the shift count becomes negative (c.f. C99 6.5.7(3)) and UBSAN reports
> 
>   UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1281:11
>   shift exponent -1 is negative
>   [...]
>   Call Trace:
>    [<ffffffff818c4d35>] dump_stack+0xbc/0x117
>    [<ffffffff818c4c79>] ? _atomic_dec_and_lock+0x169/0x169
>    [<ffffffff819411bb>] ubsan_epilogue+0xd/0x4e
>    [<ffffffff81941cbc>] __ubsan_handle_shift_out_of_bounds+0x1fb/0x254
>    [<ffffffff81941ac1>] ? __ubsan_handle_load_invalid_value+0x158/0x158
>    [<ffffffff816e93a0>] ? ext4_mb_generate_from_pa+0x590/0x590
>    [<ffffffff816502c8>] ? ext4_read_block_bitmap_nowait+0x598/0xe80
>    [<ffffffff816e7b7e>] mb_find_order_for_block+0x1ce/0x240
>    [...]
> 
> Unless compilers start to do some fancy transformations (which at least
> GCC 6.0.0 doesn't currently do), the issue is of cosmetic nature only: the
> such calculated value of bb is never used again.
> 
> Silence UBSAN by introducing another variable, bb_incr, holding the next
> increment to apply to bb and adjust that one by right shifting it by one
> position per loop iteration.
> 
> Signed-off-by: Nicolai Stange <nicstange@gmail.com>

Thanks, applied.

					- Ted
