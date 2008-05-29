From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext4: fix error processing in mb_free_blocks
Date: Wed, 28 May 2008 21:30:23 -0700
Message-ID: <20080528213023.a703d10c.akpm@linux-foundation.org>
References: <483E212E.1020309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbYE2Eau (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 00:30:50 -0400
In-Reply-To: <483E212E.1020309@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 29 May 2008 11:21:18 +0800 Shen Feng <shen@cn.fujitsu.com> wrote:

> The error processing of the return value of mb_free_blocks
> is meanless because it only return 0. This fix includes
> *make mb_free_blocks return void
> *remove the error processing part in callers

This:

> *unlock group before calling ext4_error in mb_free_blocks

fixes a potential deadlock.

> @@ -1084,11 +1084,12 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
>  			blocknr += block;
>  			blocknr +=
>  			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
> -
> +			ext4_unlock_group(sb, e4b->bd_group);
>  			ext4_error(sb, __func__, "double-free of inode"
>  				   " %lu's block %llu(bit %u in group %lu)\n",
>  				   inode ? inode->i_ino : 0, blocknr, block,
>  				   e4b->bd_group);
> +			ext4_lock_group(sb, e4b->bd_group);
>  		}
>  		mb_clear_bit(block, EXT4_MB_BITMAP(e4b));
>  		e4b->bd_info->bb_counters[order]++;

but are we sure we can just drop the lock and then cheerfully proceed? 
Whatever data that lock is protecting might have changed..

A safer-looking fix would be to return an error from mb_free_blocks()
and handle the in the caller, once the ext4_unlock_group() has been
performed.

