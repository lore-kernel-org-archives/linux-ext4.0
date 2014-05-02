From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 08/37] mke2fs: set gdt csum when creating packed fs
Date: Fri, 2 May 2014 13:55:59 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021355380.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231315.31890.10293.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbaEBL4E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 07:56:04 -0400
In-Reply-To: <20140501231315.31890.10293.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:13:15 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 08/37] mke2fs: set gdt csum when creating packed fs
> 
> When we're creating a fs with metadata blocks packed at the beginning
> (packed_meta_blocks=1 in mke2fs.conf), set the group descriptor
> checksum or else we create DOA filesystems with checksum errors.

Makes sense. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/mke2fs.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 6507d0d..fd6259d 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -383,6 +383,7 @@ static errcode_t packed_allocate_tables(ext2_filsys fs)
>  		ext2fs_block_alloc_stats_range(fs, goal,
>  					       fs->inode_blocks_per_group, +1);
>  		ext2fs_inode_table_loc_set(fs, i, goal);
> +		ext2fs_group_desc_csum_set(fs, i);
>  	}
>  	return 0;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
