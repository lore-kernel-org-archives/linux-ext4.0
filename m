From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH] fs/ext4: mb_find_order_for_block(): silence UBSAN
Date: Sun, 17 Apr 2016 10:35:09 +0200
Message-ID: <87twj0pr9e.fsf@gmail.com>
References: <1458417247-3164-1-git-send-email-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458417247-3164-1-git-send-email-nicstange@gmail.com> (Nicolai
	Stange's message of "Sat, 19 Mar 2016 20:54:07 +0100")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Nicolai Stange <nicstange@gmail.com> writes:
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


FYI, this UBSAN splat has been independently reported here:

  https://bugzilla.kernel.org/show_bug.cgi?id=114701

An alternative patch has been attached at this bug report.

>
> Unless compilers start to do some fancy transformations (which at least
> GCC 4.6.0 doesn't currently do), the issue is of cosmetic nature only: the
> such calculated value of bb is never used again.
>
> Silence UBSAN by introducing another variable, bb_incr, holding the next
> increment to apply to bb and adjust that one by right shifting it by one
> position per loop iteration.
>
> Signed-off-by: Nicolai Stange <nicstange@gmail.com>
> ---
>  Applicable to linux-next-20160318
>
>  fs/ext4/mballoc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 50e05df..4bc89fe 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1266,6 +1266,7 @@ static void ext4_mb_unload_buddy(struct ext4_buddy *e4b)
>  static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
>  {
>  	int order = 1;
> +	int bb_incr = 1 << (e4b->bd_blkbits - 1);
>  	void *bb;
>  
>  	BUG_ON(e4b->bd_bitmap == e4b->bd_buddy);
> @@ -1278,7 +1279,8 @@ static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
>  			/* this block is part of buddy of order 'order' */
>  			return order;
>  		}
> -		bb += 1 << (e4b->bd_blkbits - order);
> +		bb += bb_incr;
> +		bb_incr >>= 1;
>  		order++;
>  	}
>  	return 0;
