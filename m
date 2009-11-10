From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] libext2fs: don't swap extent-based journal backup on read
Date: Tue, 10 Nov 2009 16:14:05 -0700
Message-ID: <96D72157-6B78-4AAE-A034-47E9E5BD205D@sun.com>
References: <4AF9D0F8.6020609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55801 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529AbZKJXOJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Nov 2009 18:14:09 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAANEClG027139
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2009 15:14:12 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSX00L001UE0Z00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 10 Nov 2009 15:14:12 -0800 (PST)
In-reply-to: <4AF9D0F8.6020609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-10, at 13:45, Eric Sandeen wrote:
> The f_illitable_flexbg test was failing on ppc, because
> e2fsck_move_ext3_journal is doing a direct memcmp of i_block with
> s_jnl_blocks, and failing.
>
> This is because we don't swap extent data on read from disk; rather
> we do it when we access the extents.  However, ext2fs_swap_super
> was swapping s_jnl_blocks unconditionally, so these didn't match.
>
> Looks like we need to treat s_jnl_blocks the same as i_block, and
> swap it on access, not on read.  Except for the last i_size bit...
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Makes sense:
Reviewed-by: Andreas Dilger <adilger@sun.com>

> ---
>
> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index 42bc01e..38f5f9b 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -73,9 +73,19 @@ void ext2fs_swap_super(struct ext2_super_block *  
> sb)
> 	sb->s_kbytes_written = ext2fs_swab64(sb->s_kbytes_written);
> 	for (i=0; i < 4; i++)
> 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
> +
> +	/* if journal backup is for a valid extent-based journal... */
> +	if (!ext2fs_extent_header_verify(sb->s_jnl_blocks,
> +					 sizeof(sb->s_jnl_blocks))) {
> +		/* ... swap only the journal i_size */
> +		sb->s_jnl_blocks[16] = ext2fs_swab32(sb->s_jnl_blocks[16]);
> +		/* and the extent data is not swapped on read */
> +		return;
> +	}
> +
> +	/* direct/indirect journal: swap it all */
> 	for (i=0; i < 17; i++)
> 		sb->s_jnl_blocks[i] = ext2fs_swab32(sb->s_jnl_blocks[i]);

I wouldn't object to fixing the formatting above to "for (i = 0; ...)"

> }
>
> void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
>
>
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

