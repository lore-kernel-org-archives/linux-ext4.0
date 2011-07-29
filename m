From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [patch 1/1] ext4: use proper little-endian bitops
Date: Fri, 29 Jul 2011 11:43:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1107291109460.4293@dhcp-27-109.brq.redhat.com>
References: <201107282055.p6SKtKp5008047@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, akinobu.mita@gmail.com,
	adilger.kernel@dilger.ca
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab1G2JoT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jul 2011 05:44:19 -0400
In-Reply-To: <201107282055.p6SKtKp5008047@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 28 Jul 2011, akpm@linux-foundation.org wrote:

> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_le() for
> ext4.  Only two ext4_{set,clear}_bit() calls check the return value.  The
> rest of calls ignore the return value and they can be replaced with
> __{set,clear}_bit_le().
> 
> This changes ext4_{set,clear}_bit() from __test_and_{set,clear}_bit_le()
> to __{set,clear}_bit_le() and introduces ext4_test_and_{set,clear}_bit()
> for the two places where old bit needs to be returned.
> 
> This ext4_{set,clear}_bit() change is considered safe, because if someone
> uses these macros without noticing the change, new ext4_{set,clear}_bit
> don't have return value and causes compiler errors where the return value
> is used.
> 
> This also removes unused ext4_find_first_zero_bit().

Hi Anikobu,

I have some comments bellow.

> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ext4/ext4.h   |    7 ++++---
>  fs/ext4/ialloc.c |    4 ++--
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff -puN fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops fs/ext4/ext4.h
> --- a/fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops
> +++ a/fs/ext4/ext4.h
> @@ -931,12 +931,13 @@ struct ext4_inode_info {
>  #define test_opt2(sb, opt)		(EXT4_SB(sb)->s_mount_opt2 & \
>  					 EXT4_MOUNT2_##opt)
>  
> -#define ext4_set_bit			__test_and_set_bit_le
> +#define ext4_test_and_set_bit		__test_and_set_bit_le
> +#define ext4_set_bit			__set_bit_le
>  #define ext4_set_bit_atomic		ext2_set_bit_atomic
We can remove this since it is not used anywhere and it is just a macro
for test_and_set_bit_le() anyway.

> -#define ext4_clear_bit			__test_and_clear_bit_le
> +#define ext4_test_and_clear_bit		__test_and_clear_bit_le
> +#define ext4_clear_bit			__clear_bit_le
>  #define ext4_clear_bit_atomic		ext2_clear_bit_atomic
Not used as well.

>  #define ext4_test_bit			test_bit_le
> -#define ext4_find_first_zero_bit	find_first_zero_bit_le
>  #define ext4_find_next_zero_bit		find_next_zero_bit_le
>  #define ext4_find_next_bit		find_next_bit_le

Other than that it looks good. You can add my 

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas

>  
> diff -puN fs/ext4/ialloc.c~ext4-use-proper-little-endian-bitops fs/ext4/ialloc.c
> --- a/fs/ext4/ialloc.c~ext4-use-proper-little-endian-bitops
> +++ a/fs/ext4/ialloc.c
> @@ -252,7 +252,7 @@ void ext4_free_inode(handle_t *handle, s
>  		fatal = ext4_journal_get_write_access(handle, bh2);
>  	}
>  	ext4_lock_group(sb, block_group);
> -	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
> +	cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
>  	if (fatal || !cleared) {
>  		ext4_unlock_group(sb, block_group);
>  		goto out;
> @@ -729,7 +729,7 @@ static int ext4_claim_inode(struct super
>  	 */
>  	down_read(&grp->alloc_sem);
>  	ext4_lock_group(sb, group);
> -	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
> +	if (ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data)) {
>  		/* not a free inode */
>  		retval = 1;
>  		goto err_ret;
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

