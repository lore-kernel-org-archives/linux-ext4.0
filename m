From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 1/4] ext4: fix trim length underflow with small trim length.
Date: Fri, 01 Jul 2011 18:15:30 +0800
Message-ID: <4E0D9E42.3000606@tao.ma>
References: <4E0C8B6C.8030403@tao.ma> <1309445439-3753-1-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1107011140400.4168@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:53348 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755677Ab1GAKPs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 06:15:48 -0400
In-Reply-To: <alpine.LFD.2.00.1107011140400.4168@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,
On 07/01/2011 05:45 PM, Lukas Czerner wrote:
> On Thu, 30 Jun 2011, Tao Ma wrote:
> 
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In 0f0a25b, we adjust 'len' with s_first_data_block - start, but
>> it could underflow in case blocksize=1K, fstrim_range.len=512 and
>> fstrim_range.start = 0. In this case, when we run the code:
>> len -= first_data_blk - start; len will be underflow to -1ULL.
>> In the end, although we are safe that last_group check later will limit
>> the trim to the whole volume, but that isn't what the user really want.
>>
>> So this patch fix it. It also adds the check for 'start' like ext3 so that
>> we can break immediately if the start is invalid.
> 
> Hi Tao,
> 
> thanks for the resend!
> 
>>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>>  fs/ext4/mballoc.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 6ed859d..2336424 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4904,6 +4904,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>>  
>>  	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
>>  		return -EINVAL;
>> +	if (start >= ext4_blocks_count(EXT4_SB(sb)->s_es) ||
>> +	    start + len <= first_data_blk)
>> +		goto out;
> 
> We should really return -EINVAL in case that start is beyond the
> filesystem. However we can not return -EINVAL in case that start+len is
> before the first data block, because it would require user to know fs
> internals.
uh, actually I have checked what ext3 does and in case of start >
block_count, ext3 returns 0, not EINVAL and I made it to work like ext3.
So we should change it also?

Thanks
Tao
> 
> So simply doing this, should be enough:
> 
> 	if (start + len <= first_data_blk)
> 		goto out;
> 
> and the code later
> 
> 	if (first_group > last_group)
> 		return -EINVAL;
> 
> will handle the rest.
> 
> Thanks!
> -Lukas
> 
> 
>>  	if (start < first_data_blk) {
>>  		len -= first_data_blk - start;
>>  		start = first_data_blk;
>> @@ -4952,5 +4955,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>>  	}
>>  	range->len = trimmed * sb->s_blocksize;
>>  
>> +out:
>>  	return ret;
>>  }
>>
> 

