From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs FTBFS: allocate inode table wholly within group
Date: Thu, 04 Jul 2013 10:19:27 -0400
Message-ID: <51D5846F.10400@redhat.com>
References: <51D3269B.5080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab3GDOTj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jul 2013 10:19:39 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r64EJdoi031325
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jul 2013 10:19:39 -0400
Received: from [IPv6:::1] (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r64EJLjv020775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jul 2013 10:19:38 -0400
In-Reply-To: <51D3269B.5080608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/2/13 3:14 PM, Eric Sandeen wrote:
> Building e2fsprogs 1.42.8 on ppc, I got this:
> 
> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed

You can add a RH FTBFS bug to the commit now if you like, 

[Bug 980519] New: FTBFS: self checks failure: Tests failed: r_1024_small_bg

https://bugzilla.redhat.com/show_bug.cgi?id=980519

since Karsten Hopp has now reported it for Rawhide as well.

-Eric


> Because during the resize step it did this:
> 
> Itable move group 1 block 1030->1092 (diff 62)
> 
> but during e2fsck it found:
> 
> /tmp/e2fsprogs-tmp.uiFhgP: Inode table for group 1 is not in group.  (block 1092)
> 
> i.e. from dumpe2fs we can see:
> 
> Group 1: (Blocks 1025-1110)
>   Backup superblock at 1025, Group descriptors at 1026-1026
>   Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
>   Inode table at 1092-1123 (+67)
>                       ^^^^ beyond end of block group
> 
> ext2fs_allocate_group_table() currently sends the last block of the
> group as an acceptable *starting* point for the inode table allocation.
> 
> Because the inode table may be several blocks, and must reside wholly
> within the group, move the last acceptable starting block back by this
> amount so that the allocated range cannot extend past the end of the
> group.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. I *think* this fixes it; I've not convinced myself that the failure
> is 100% deterministic, so extra eyeballs on the patch are welcome.
> 
> Thanks,
> -Eric
> 
> Index: e2fsprogs-1.42.8/lib/ext2fs/alloc_tables.c
> ===================================================================
> --- e2fsprogs-1.42.8.orig/lib/ext2fs/alloc_tables.c
> +++ e2fsprogs-1.42.8/lib/ext2fs/alloc_tables.c
> @@ -200,6 +200,9 @@ errcode_t ext2fs_allocate_group_table(ex
>  	}
>  
>  	if (!ext2fs_inode_table_loc(fs, group)) {
> +		/* Inode table must fit within group, so adjust last blk */
> +		last_blk -= (fs->inode_blocks_per_group - 1);
> +
>  		retval = ext2fs_get_free_blocks2(fs, group_blk, last_blk,
>  						fs->inode_blocks_per_group,
>  						bmap, &new_blk);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

