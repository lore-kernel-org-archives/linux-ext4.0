From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH]ext4: fix s_dirty_blocks_counter if block allocation	failed
 with nodelalloc
Date: Thu, 04 Dec 2008 16:38:04 +0800
Message-ID: <493796EC.10404@cn.fujitsu.com>
References: <4933BAC2.6080004@rs.jp.nec.com> <20081201103641.GA13242@skywalker> <493731FD.5040809@rs.jp.nec.com> <20081204050745.GC10787@skywalker> <493795BA.4010507@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYLDIjp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Dec 2008 03:39:45 -0500
In-Reply-To: <493795BA.4010507@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira Fujita wrote:
> 
> Aneesh Kumar K.V wrote:
>> On Thu, Dec 04, 2008 at 10:27:25AM +0900, Akira Fujita wrote:
>>> Hi Aneesh,
>>> Aneesh Kumar K.V wrote:
>>>> On Mon, Dec 01, 2008 at 07:21:54PM +0900, Akira Fujita wrote:
>>>>> ext4: Fix s_dirty_blocks_counter if block allocation failed with
>>>>> nodelalloc
>>>>>
>>>>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>>>>>
>>>>> If block allocation failed after marking claimed blocks as dirty
>>>>> blocks
>>>>> with nodelalloc, we have to subtract these blocks from
>>>>> s_dirty_blocks_counter in error handling.
>>>>> Otherwise s_dirty_blocks_counter goes wrong so that
>>>>> filesystem's free blocks decreases incorrectly.
>>>> Why did the block allocation fail ? With delayed allocation ENOSPC
>>>> should not happen during block allocation. That would mean we did
>>>> something wrong in block reservation.
>>> My case was *nodelalloc* and FS was almost full.
>>> This problem occurs in multiple defrag running in short time.
>>> Usually defrag releases temporary inode's blocks with iput,
>>> then FS free blocks are recover but contiguous blocks do not recover
>>> until next journal commit.
>>> so we can not re-use contiguous blocks immediately.
>>> There are enough free blocks in FS so that
>>> ext4_claim_free_blocks marks claimed blocks as dirty,
>>> but ext4_regular_allocator can not find enough blocks,
>>> so mb_new_blocks returns ENOSPC without decreasing dirty blocks.
>>>
>> ok how about doing the check once in ext4_mb_new_blocks.
> 
> It works fine.  Thank you.
> Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> 

I'll test it when I'm free and have access to the test machine. :)

But not this week..

>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index bacc2f4..22d31c3 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4550,7 +4550,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>>      }
>>      if (ar->len == 0) {
>>          *errp = -EDQUOT;
>> -        return 0;
>> +        goto out3;
>>      }
>>      inquota = ar->len;
>>  
>> @@ -4623,6 +4623,13 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>>  out1:
>>      if (ar->len < inquota)
>>          DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
>> +out3:
>> +    if (!ar->len) {
>> +        if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
>> +            /* release all the reserved blocks if non delalloc */
>> +            percpu_counter_sub(&sbi->s_dirtyblocks_counter,
>> +                        reserv_blks);
>> +    }
>>  
>>      return block;
>>  }
> 
> 
