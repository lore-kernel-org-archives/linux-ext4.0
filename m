From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/6] libext2fs: add ext2fs_bitcount() function
Date: Mon, 26 Nov 2012 11:30:55 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211261123400.18234@localhost>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu> <1353803794-11593-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab2KZKbA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 05:31:00 -0500
In-Reply-To: <1353803794-11593-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 24 Nov 2012, Theodore Ts'o wrote:

> Date: Sat, 24 Nov 2012 19:36:31 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 3/6] libext2fs: add ext2fs_bitcount() function
> 
> This function efficiently counts the number of bits in a block of
> memory.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/bitops.c        | 35 +++++++++++++++++++++++++++++++++++
>  lib/ext2fs/bitops.h        |  1 +
>  lib/ext2fs/tst_bitmaps.c   |  1 +
>  lib/ext2fs/tst_bitmaps_exp |  3 +++
>  4 files changed, 40 insertions(+)
> 
> diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
> index 9322a35..7f5b66f 100644
> --- a/lib/ext2fs/bitops.c
> +++ b/lib/ext2fs/bitops.c
> @@ -116,3 +116,38 @@ int ext2fs_test_bit64(__u64 nr, const void * addr)
>  	return (mask & *ADDR);
>  }
>  
> +static unsigned int popcount8(unsigned int w)
> +{
> +	unsigned int res = w - ((w >> 1) & 0x55);
> +	res = (res & 0x33) + ((res >> 2) & 0x33);
> +	return (res + (res >> 4)) & 0x0F;
> +}
> +
> +static unsigned int popcount32(unsigned int w)
> +{
> +	unsigned int res = w - ((w >> 1) & 0x55555555);
> +	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
> +	res = (res + (res >> 4)) & 0x0F0F0F0F;
> +	res = res + (res >> 8);
> +	return (res + (res >> 16)) & 0x000000FF;
> +}
> +
> +unsigned int ext2fs_bitcount(const void *addr, unsigned int count)
> +{
> +	const unsigned char *cp = addr;
> +	const __u32 *p = addr;
> +	unsigned int res = 0;
> +

Again it is assumed that 8 will always be aliquot of 'count', but
it might be worth having a check for that ?

Otherwise it looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> +	if ((((unsigned long) addr) & 3) == 0) {
> +		while (count > 4) {
> +			res += popcount32(*p++);
> +			count -= 4;
> +		}
> +		cp = (const unsigned char *) p;
> +	}
> +	while (count > 0) {
> +		res += popcount8(*cp++);
> +		count--;
> +	}
> +	return res;
> +}
> diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
> index 526870f..17e707c 100644
> --- a/lib/ext2fs/bitops.h
> +++ b/lib/ext2fs/bitops.h
> @@ -686,6 +686,7 @@ extern int ext2fs_test_bit(unsigned int nr, const void * addr);
>  extern int ext2fs_set_bit64(__u64 nr,void * addr);
>  extern int ext2fs_clear_bit64(__u64 nr, void * addr);
>  extern int ext2fs_test_bit64(__u64 nr, const void * addr);
> +extern unsigned int ext2fs_bitcount(const void *addr, unsigned int count);
>  
>  #ifdef NO_INLINE_FUNCS
>  extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
> diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
> index 5da3693..2a76292 100644
> --- a/lib/ext2fs/tst_bitmaps.c
> +++ b/lib/ext2fs/tst_bitmaps.c
> @@ -270,6 +270,7 @@ void dump_bitmap(ext2fs_generic_bitmap bmap, unsigned int start, unsigned num)
>  	for (i=0; i < len; i++)
>  		printf("%02x", buf[i]);
>  	printf("\n");
> +	printf("bits set: %u\n", ext2fs_bitcount(buf, len));
>  	free(buf);
>  }
>  
> diff --git a/lib/ext2fs/tst_bitmaps_exp b/lib/ext2fs/tst_bitmaps_exp
> index 2d406ce..893f315 100644
> --- a/lib/ext2fs/tst_bitmaps_exp
> +++ b/lib/ext2fs/tst_bitmaps_exp
> @@ -36,6 +36,7 @@ tst_bitmaps: testb 16
>  Block 16 is set
>  tst_bitmaps: dump_bb
>  block bitmap: 00f80000000000000000000000000000
> +bits set: 5
>  tst_bitmaps: ffzb 11 16
>  First unmarked block is 11
>  tst_bitmaps: ffzb 12 16
> @@ -64,6 +65,7 @@ tst_bitmaps: setb 12 7
>  Marking blocks 12 to 18
>  tst_bitmaps: dump_bb
>  block bitmap: 00f80300000000000000000000000000
> +bits set: 7
>  tst_bitmaps: seti 2
>  Setting inode 2, was clear before
>  tst_bitmaps: seti 5
> @@ -82,6 +84,7 @@ tst_bitmaps: testi 1
>  Inode 1 is clear
>  tst_bitmaps: dump_ib
>  inode bitmap: 1e000000
> +bits set: 4
>  tst_bitmaps: ffzi 1 6
>  First unmarked inode is 1
>  tst_bitmaps: ffzi 2 5
> 
