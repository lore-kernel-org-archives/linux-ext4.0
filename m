From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: ext4_find_next_zero_bit needs an aligned address
 on some arch
Date: Wed, 20 Feb 2008 08:44:34 -0600
Message-ID: <47BC3CD2.4060808@redhat.com>
References: <1203518487-7214-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYBTPDJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 10:03:09 -0500
In-Reply-To: <1203518487-7214-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> ext4_find_next_zero_bit and ext4_find_next_bit needs a long aligned
> address on x8_64. Add mb_find_next_zero_bit and mb_find_next_bit
> and use them in the mballoc.
> 
> Fix: https://bugzilla.redhat.com/show_bug.cgi?id=433286
> 
> Eric Sandeen debugged the problem and suggested the fix.

Thanks for fixing this up, Aneesh.

Thanks for getting rid of the magic looks-like-a-function-but-isn't
#define, too.  :)

The testcase I reproduced this with (basically just rebuilding a kernel
src.rpm on ext4) seems to pass with change.

As we had it, the direct call of find_next_zero_bit seemed to almost do
the right thing, except it scanned more bits than we asked for, up to 64
bits' worth, and so a) wandered off our page and b) returned an answer
that was > the size we asked it to scan in some cases.

(It's unfortunate that the alignment code for this got taken out in the
first place, only to put it back now, but I guess I didn't speak up
then, either...)

Really, I think the core bitmap functions could use some fixing, or at
least some warnings if it's given an address it can't cope with properly.

But for now....

Acked-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> CC:Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/ext4/mballoc.c |   62 ++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 40 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 89772b9..ccddd21 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -627,21 +627,19 @@ static ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
>  	return block;
>  }
>  
> +static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
> +{
>  #if BITS_PER_LONG == 64
> -#define mb_correct_addr_and_bit(bit, addr)		\
> -{							\
> -	bit += ((unsigned long) addr & 7UL) << 3;	\
> -	addr = (void *) ((unsigned long) addr & ~7UL);	\
> -}
> +	*bit += ((unsigned long) addr & 7UL) << 3;
> +	addr = (void *) ((unsigned long) addr & ~7UL);
>  #elif BITS_PER_LONG == 32
> -#define mb_correct_addr_and_bit(bit, addr)		\
> -{							\
> -	bit += ((unsigned long) addr & 3UL) << 3;	\
> -	addr = (void *) ((unsigned long) addr & ~3UL);	\
> -}
> +	*bit += ((unsigned long) addr & 3UL) << 3;
> +	addr = (void *) ((unsigned long) addr & ~3UL);
>  #else
>  #error "how many bits you are?!"
>  #endif
> +	return addr;
> +}
>  
>  static inline int mb_test_bit(int bit, void *addr)
>  {
> @@ -649,34 +647,54 @@ static inline int mb_test_bit(int bit, void *addr)
>  	 * ext4_test_bit on architecture like powerpc
>  	 * needs unsigned long aligned address
>  	 */
> -	mb_correct_addr_and_bit(bit, addr);
> +	addr = mb_correct_addr_and_bit(&bit, addr);
>  	return ext4_test_bit(bit, addr);
>  }
>  
>  static inline void mb_set_bit(int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit, addr);
> +	addr = mb_correct_addr_and_bit(&bit, addr);
>  	ext4_set_bit(bit, addr);
>  }
>  
>  static inline void mb_set_bit_atomic(spinlock_t *lock, int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit, addr);
> +	addr = mb_correct_addr_and_bit(&bit, addr);
>  	ext4_set_bit_atomic(lock, bit, addr);
>  }
>  
>  static inline void mb_clear_bit(int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit, addr);
> +	addr = mb_correct_addr_and_bit(&bit, addr);
>  	ext4_clear_bit(bit, addr);
>  }
>  
>  static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
>  {
> -	mb_correct_addr_and_bit(bit, addr);
> +	addr = mb_correct_addr_and_bit(&bit, addr);
>  	ext4_clear_bit_atomic(lock, bit, addr);
>  }
>  
> +static inline int mb_find_next_zero_bit(void *addr, int max, int start)
> +{
> +	int fix = 0;
> +	addr = mb_correct_addr_and_bit(&fix, addr);
> +	max += fix;
> +	start += fix;
> +
> +	return ext4_find_next_zero_bit(addr, max, start) - fix;
> +}
> +
> +static inline int mb_find_next_bit(void *addr, int max, int start)
> +{
> +	int fix = 0;
> +	addr = mb_correct_addr_and_bit(&fix, addr);
> +	max += fix;
> +	start += fix;
> +
> +	return ext4_find_next_bit(addr, max, start) - fix;
> +}
> +
>  static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
>  {
>  	char *bb;
> @@ -946,12 +964,12 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
>  
>  	/* initialize buddy from bitmap which is aggregation
>  	 * of on-disk bitmap and preallocations */
> -	i = ext4_find_next_zero_bit(bitmap, max, 0);
> +	i = mb_find_next_zero_bit(bitmap, max, 0);
>  	grp->bb_first_free = i;
>  	while (i < max) {
>  		fragments++;
>  		first = i;
> -		i = ext4_find_next_bit(bitmap, max, i);
> +		i = mb_find_next_bit(bitmap, max, i);
>  		len = i - first;
>  		free += len;
>  		if (len > 1)
> @@ -959,7 +977,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
>  		else
>  			grp->bb_counters[0]++;
>  		if (i < max)
> -			i = ext4_find_next_zero_bit(bitmap, max, i);
> +			i = mb_find_next_zero_bit(bitmap, max, i);
>  	}
>  	grp->bb_fragments = fragments;
>  
> @@ -1783,7 +1801,7 @@ static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
>  		buddy = mb_find_buddy(e4b, i, &max);
>  		BUG_ON(buddy == NULL);
>  
> -		k = ext4_find_next_zero_bit(buddy, max, 0);
> +		k = mb_find_next_zero_bit(buddy, max, 0);
>  		BUG_ON(k >= max);
>  
>  		ac->ac_found++;
> @@ -1823,7 +1841,7 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
>  	i = e4b->bd_info->bb_first_free;
>  
>  	while (free && ac->ac_status == AC_STATUS_CONTINUE) {
> -		i = ext4_find_next_zero_bit(bitmap,
> +		i = mb_find_next_zero_bit(bitmap,
>  						EXT4_BLOCKS_PER_GROUP(sb), i);
>  		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
>  			/*
> @@ -3744,10 +3762,10 @@ static noinline int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
>  	}
>  
>  	while (bit < end) {
> -		bit = ext4_find_next_zero_bit(bitmap_bh->b_data, end, bit);
> +		bit = mb_find_next_zero_bit(bitmap_bh->b_data, end, bit);
>  		if (bit >= end)
>  			break;
> -		next = ext4_find_next_bit(bitmap_bh->b_data, end, bit);
> +		next = mb_find_next_bit(bitmap_bh->b_data, end, bit);
>  		if (next > end)
>  			next = end;
>  		start = group * EXT4_BLOCKS_PER_GROUP(sb) + bit +
