From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Wed, 02 Sep 2009 23:51:35 -0500
Message-ID: <4A9F4B57.9080602@redhat.com>
References: <12386.1251948115@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:15306 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZICEve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 00:51:34 -0400
In-Reply-To: <12386.1251948115@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos wrote:
> Following Andreas's suggestion, I found that ext2fs_set_gdt_csum()
> was the culprit: it used an ext2_group_desc pointer to access/set
> fields and it did that directly, not through access functions.
> 
> I'm testing the patch now, but it'll take a while, so again I'm sending
> it out for comments and to possibly try out. Even if it checks out, it
> will need some additional care once the flags situation settles down.

cool, thanks.

yep this would explain the bug (any direct access would I guess)

With this on top of my patch stack, my testcase passes, until I allocate 
something high enough that I run into yet another 32-bit overflow 
somewhere ;)

Ted, want me to collate these into a proper patch series?  I have one 
more direct access fix as well.  (and then things like ext2ed & e2imgge 
etc all need a thorough going-over too....)

We really must make these structs opaque or something or it will be 
endless pain...

Minor comments below.

> Thanks,
> Nick
> 
> From 6a3b83cda1bcd1e3594515ee888f175bf5cc7906 Mon Sep 17 00:00:00 2001
> From: Nick Dokos <nicholas.dokos@hp.com>
> Date: Wed, 2 Sep 2009 23:00:23 -0400
> Subject: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
> 
> Replace all field accesses with calls to access functions.
> Most importantly, get rid of the mis-declared group descriptor
> pointer which caused the wrong fields to be updated.

Not quite sure what you mean by this?  It worked ok for the "old" size ...

> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> ---
>  lib/ext2fs/csum.c |   30 +++++++++++++++++-------------
>  1 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
> index a0f25e3..def3ddd 100644
> --- a/lib/ext2fs/csum.c
> +++ b/lib/ext2fs/csum.c
> @@ -105,7 +105,6 @@ static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
>  errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
>  {
>  	struct ext2_super_block *sb = fs->super;
> -	struct ext2_group_desc *bg = fs->group_desc;
>  	int dirty = 0;
>  	dgrp_t i;
>  
> @@ -116,27 +115,32 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
>  					EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
>  		return 0;
>  
> -	for (i = 0; i < fs->group_desc_count; i++, bg++) {
> -		int old_csum = bg->bg_checksum;
> -		int old_unused = bg->bg_itable_unused;
> -		int old_flags = bg->bg_flags;
> +	for (i = 0; i < fs->group_desc_count; i++) {
> +		unsigned int old_csum = ext2fs_bg_checksum(fs, i);
> +                int old_unused = ext2fs_bg_itable_unused(fs, i);

whitespace problem here, use tabs

> +		unsigned int old_flags = ext2fs_bg_flags(fs, i);
> +                int old_free_inodes_count = ext2fs_bg_free_inodes_count(fs, i);

ditto

also, strictly, csum & flags are 16 bits, unused is (today) 64 bits ....

> +             

extra blank line?

>  
> -		if (bg->bg_free_inodes_count == sb->s_inodes_per_group) {
> -			bg->bg_flags |= EXT2_BG_INODE_UNINIT;
> -			bg->bg_itable_unused = sb->s_inodes_per_group;
> +		if (old_free_inodes_count == sb->s_inodes_per_group) {
> +			ext2fs_bg_flags_set(fs, i, old_flags | EXT2_BG_INODE_UNINIT);

better this I think (though I guess it may change ...):

+			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_UNINIT);

> +			ext2fs_bg_itable_unused_set(fs, i, sb->s_inodes_per_group);
>  		} else {
> -			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
> -			bg->bg_itable_unused = sb->s_inodes_per_group -
> +			int unused = sb->s_inodes_per_group -
>  				find_last_inode_ingrp(fs->inode_map,
>  						      sb->s_inodes_per_group,i);
> +
> +			ext2fs_bg_flags_set(fs, i, old_flags & ~EXT2_BG_INODE_UNINIT);

and this:
+			ext2fs_flag_clear(fs, i, EXT2_BG_INODE_UNINIT);

> +			
> +			ext2fs_bg_itable_unused_set(fs, i, unused);
>  		}
>  
>  		ext2fs_group_desc_csum_set(fs, i);
> -		if (old_flags != bg->bg_flags)
> +		if (old_flags != ext2fs_bg_flags(fs, i))
>  			dirty = 1;
> -		if (old_unused != bg->bg_itable_unused)
> +		if (old_unused != ext2fs_bg_itable_unused(fs, i))
>  			dirty = 1;
> -		if (old_csum != bg->bg_checksum)
> +		if (old_csum != ext2fs_bg_checksum(fs, i))
>  			dirty = 1;
>  	}
>  	if (dirty)

