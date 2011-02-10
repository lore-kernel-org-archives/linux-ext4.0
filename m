From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 4/4] ext4: Speed up FITRIM by recording flags in ext4_group_info.
Date: Thu, 10 Feb 2011 11:56:29 +0800
Message-ID: <4D5361ED.5030108@tao.ma>
References: <4D522B9B.5070707@tao.ma> <1297231048-3458-4-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1102091445580.5596@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:40285 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754021Ab1BJD4o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 22:56:44 -0500
In-Reply-To: <alpine.LFD.2.00.1102091445580.5596@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,
On 02/09/2011 10:01 PM, Lukas Czerner wrote:
> On Wed, 9 Feb 2011, Tao Ma wrote:
>
>    
>> From: Tao Ma<boyu.mt@taobao.com>
>>
>> In ext4, when FITRIM is called every time, we iterate all the
>> groups and do trim one by one. It is a bit time wasting if the
>> group has been trimmed and there is no change since the last
>> trim.
>>
>> So this patch adds a new flag in ext4_group_info->bb_state to
>> indicate that the group has been trimmed, and it will be cleared
>> if some blocks is freed(in release_blocks_on_commit). Another
>> trim_minlen is added in ext4_sb_info to record the last minlen
>> we use to trim the volume, so that if the caller provide a small
>> one, we will go on the trim regardless of the bb_state. The idea
>> is inspired by Andreas  and Lukas Czerner.
>>      
> Hi Tao,
>
> This is great, thanks for the patch! Do you have any benchmark numbers
> showing how much does it improve FSTRIM time ? It seems it might help a
> lot. Couple of comments bellow.
>    
<snip>
>    
>> @@ -4772,6 +4785,10 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
>>
>>   	ext4_lock_group(sb, group);
>>
>> +	if (EXT4_MB_GRP_HAS_BEEN_TRIMMED(e4b->bd_info)&&
>> +	    minblocks>= EXT4_SB(sb)->trim_minlen)
>> +		goto out;
>> +
>>      
> I think this can be placed in the ext4_trim_fs() in the for() loop so we can
> avoid unnecessary call to ext4_trim_all_free.
>    
I remembered why I put the check here. We have to check this flag with 
the group locked. So in ext4_trim_fs, we don't lock the group and it is 
unsafe to check it there since we may free some blocks and clear the bit 
in the same time in release_blocks_on_commit.

Regards,
Tao
