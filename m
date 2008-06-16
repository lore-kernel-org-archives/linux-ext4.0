From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: fix ext4_init_block_bitmap() for metablock block
	group
Date: Mon, 16 Jun 2008 13:19:02 -0600
Message-ID: <20080616191902.GU3726@webber.adilger.int>
References: <20080615142455.GA3502@localhost.localdomain>
 <20080616051859.GK3726@webber.adilger.int>
 <20080616141016.GA19080@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61395 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYFPTTM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 15:19:12 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5GJJBd1024324
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 12:19:11 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2K00501LGQ6400@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 16 Jun 2008 12:19:11 -0700 (PDT)
In-reply-to: <20080616141016.GA19080@localhost.localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 16, 2008  23:10 +0900, Akinobu Mita wrote:
> Looks good to me. But I'd like to divide into the change into simple
> bugfix and cleanup patch in order to clarify the each change.
> 
> Here is a bugfix only patch.
> 
> From: Akinobu Mita <akinobu.mita@gmail.com>
> Subject: ext4: fix ext4_init_block_bitmap() for metablock block group
> 
> When meta_bg feature is enabled and s_first_meta_bg != 0, 
> ext4_init_block_bitmap() miscalculates the number of block used by
> the group descriptor table (0 or 1 for metablock block group)
> 
> group_rel in the original code should be calculated by:
> 
>         group_rel = block_group % EXT4_DESC_PER_BLOCK(sb);
> 
> No need to subtract s_first_meta_bg from brock_group.
> It will be equivalent what ext4_bg_num_gdb_meta() does
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Stephen Tweedie <sct@redhat.com>
> Cc: adilger@clusterfs.com
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Theodore Tso <tytso@MIT.EDU>

Acked-by: Andreas Dilger <adilger@sun.com>

> ---
>  fs/ext4/balloc.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: 2.6-git/fs/ext4/balloc.c
> ===================================================================
> --- 2.6-git.orig/fs/ext4/balloc.c
> +++ 2.6-git/fs/ext4/balloc.c
> @@ -121,9 +121,8 @@ unsigned ext4_init_block_bitmap(struct s
>  				le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
>  		}
>  	} else { /* For META_BG_BLOCK_GROUPS */
> -		int group_rel = (block_group -
> -				 le32_to_cpu(sbi->s_es->s_first_meta_bg)) %
> -				EXT4_DESC_PER_BLOCK(sb);
> +		int group_rel = block_group % EXT4_DESC_PER_BLOCK(sb);
> +
>  		if (group_rel == 0 || group_rel == 1 ||
>  		    (group_rel == EXT4_DESC_PER_BLOCK(sb) - 1))
>  			bit_max += 1;

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

