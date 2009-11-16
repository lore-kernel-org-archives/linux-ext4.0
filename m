From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Re: s_first_meta_bg treatment incompatibility between kernel and
 e2fsprogs
Date: Mon, 16 Nov 2009 16:51:57 +0100
Message-ID: <4B01751D.1010705@partition-saving.com>
References: <4AFAA95C.5000304@partition-saving.com> <20091115042057.GC4323@mit.edu> <4AFFD7BD.1080300@partition-saving.com> <20091115192355.GD4323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:59790 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbZKPPu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 10:50:29 -0500
In-Reply-To: <20091115192355.GD4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Theodore Tso wrote:
> On Sun, Nov 15, 2009 at 11:28:13AM +0100, Damien Guibouret wrote:

[...]

> As far as the matter of taste issue is concerned, I think we already
> have too many static functions with a single caller, and it actually
> makes the code harder to understand.  So adding yet another simple
> static function I think is a bad thing, not a good thing.
> 

It was just to mimic the existing function, but I agree with you.
The other difference is that it shall be applied on ext3 also.

> 
>>And I think there is some other places where kernel should be fixed when  
>>it uses s_gdb_count (but here my knowledge of the sources are not deep  
>>enough to be sure on what shall be performed).
> 
> 
> I've looked through the other areas, and the one place where I see a
> problem is in the block validity checks in ext4_iget() for the
> extended attribute block and in block_validity.c.  The former can and
> should be fixed to use the latter.
> 
> Here's the fix that I plan to be using.   Comments, anyone?
>

For the first one (on block_validity.c), as far as I understand, 
presence of superblock and descriptors blocks in a group are no more 
related in case of meta_bg group, so shouldn't be the code divided into 
2 distincts part: one to treat super block, second to treat descriptor 
blocks (I do not understand the ((i < 5) || ((i % flex_size) == 0) part 
into the test, so add it if it is trully needed), something as:
		ext4_fsblk_t firstSystemBlock = ext4_group_first_block_no(sb, i);
		unsigned long nbDescBlocks;
                 if (ext4_bg_has_super(sb, i)) {
                         add_system_zone(sbi, firstSystemBlock,
                                         1);
			firstSystemBlock++;
		}
		nbDescBlocks = ext4_bg_num_gdb(sb, i);
		if (nbDescBlocks != 0)
			add_system_zone(sbi, firstSystemBlock,
                                         nbDescBlocks);

Regards,

Damien

> 							- Ted
> 
> ext4: fix block validity checks so they work correctly with meta_bg
> 
> The block validity checks used by ext4_data_block_valid() wasn't
> correctly written to check file systems with the meta_bg feature.  Fix
> this.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/block_validity.c |    2 +-
>  fs/ext4/inode.c          |    5 +----
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
> index 50784ef..dc79b75 100644
> --- a/fs/ext4/block_validity.c
> +++ b/fs/ext4/block_validity.c
> @@ -160,7 +160,7 @@ int ext4_setup_system_zone(struct super_block *sb)
>  		if (ext4_bg_has_super(sb, i) &&
>  		    ((i < 5) || ((i % flex_size) == 0)))
>  			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
> -					sbi->s_gdb_count + 1);
> +					ext4_bg_num_gdb(sb, i) + 1);
>  		gdp = ext4_get_group_desc(sb, i, NULL);
>  		ret = add_system_zone(sbi, ext4_block_bitmap(sb, gdp), 1);
>  		if (ret)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b5cdb88..c62ca93 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4886,10 +4886,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  
>  	ret = 0;
>  	if (ei->i_file_acl &&
> -	    ((ei->i_file_acl <
> -	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
> -	       EXT4_SB(sb)->s_gdb_count)) ||
> -	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {
> +	    !ext4_data_block_valid(EXT4_SB(sb), ei->i_file_acl, 1)) {
>  		ext4_error(sb, __func__,
>  			   "bad extended attribute block %llu in inode #%lu",
>  			   ei->i_file_acl, inode->i_ino);
> 
> 

