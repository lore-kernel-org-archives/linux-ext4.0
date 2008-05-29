From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: fix error processing in mb_free_blocks
Date: Thu, 29 May 2008 13:21:20 +0800
Message-ID: <483E3D50.5010007@cn.fujitsu.com>
References: <483E212E.1020309@cn.fujitsu.com> <20080528213023.a703d10c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYE2FYA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 01:24:00 -0400
In-Reply-To: <20080528213023.a703d10c.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Andrew Morton Wrote:
> On Thu, 29 May 2008 11:21:18 +0800 Shen Feng <shen@cn.fujitsu.com> wrote:
> 
>> The error processing of the return value of mb_free_blocks
>> is meanless because it only return 0. This fix includes
>> *make mb_free_blocks return void
>> *remove the error processing part in callers
> 
> This:
> 
>> *unlock group before calling ext4_error in mb_free_blocks
> 
> fixes a potential deadlock.
> 
>> @@ -1084,11 +1084,12 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
>>  			blocknr += block;
>>  			blocknr +=
>>  			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
>> -
>> +			ext4_unlock_group(sb, e4b->bd_group);
>>  			ext4_error(sb, __func__, "double-free of inode"
>>  				   " %lu's block %llu(bit %u in group %lu)\n",
>>  				   inode ? inode->i_ino : 0, blocknr, block,
>>  				   e4b->bd_group);
>> +			ext4_lock_group(sb, e4b->bd_group);
>>  		}
>>  		mb_clear_bit(block, EXT4_MB_BITMAP(e4b));
>>  		e4b->bd_info->bb_counters[order]++;
> 
> but are we sure we can just drop the lock and then cheerfully proceed? 
> Whatever data that lock is protecting might have changed..

That's a real question to me when I fixed this.
I got the similar code in balloc.c from line 740 in ext4_free_blocks_sb.

		if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
						bit + i, bitmap_bh->b_data)) {
			jbd_unlock_bh_state(bitmap_bh);
			ext4_error(sb, __func__,
				   "bit already cleared for block %llu",
				   (ext4_fsblk_t)(block + i));
			jbd_lock_bh_state(bitmap_bh);
			BUFFER_TRACE(bitmap_bh, "bit already cleared");
		} else {
			group_freed++;
		}
 
So I did the same fix.
Maybe this also needs to be fixed.

> 
> A safer-looking fix would be to return an error from mb_free_blocks()
> and handle the in the caller, once the ext4_unlock_group() has been
> performed.
> 
> 
> 

