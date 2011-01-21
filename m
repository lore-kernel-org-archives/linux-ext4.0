From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH v2] ext3: Adjust trim start with first_data_block.
Date: Fri, 21 Jan 2011 21:59:34 +0800
Message-ID: <4D399146.3050501@tao.ma>
References: <20110119113921.GA4246@quack.suse.cz> <1295578376-3914-1-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1101211131030.3275@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:36609 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752053Ab1AUN7o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 08:59:44 -0500
In-Reply-To: <alpine.LFD.2.00.1101211131030.3275@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/21/2011 06:36 PM, Lukas Czerner wrote:
> On Fri, 21 Jan 2011, Tao Ma wrote:
>
>> From: Tao Ma<boyu.mt@taobao.com>
>>
>> As we have make the consense in the e-mail[1], the trim start should
>> be added with first_data_block. So this patch fulfill it and remove
>> the check for start<  first_data_block.
>>
>> [1] http://www.spinics.net/lists/linux-ext4/msg22737.html
>>
>> Cc: Jan Kara<jack@suse.cz>
>> Cc: Lukas Czerner<lczerner@redhat.com>
>> Signed-off-by: Tao Ma<boyu.mt@taobao.com>
>> ---
>>   fs/ext3/balloc.c |    7 ++-----
>>   1 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
>> index 971e1bd..13bfebe 100644
>> --- a/fs/ext3/balloc.c
>> +++ b/fs/ext3/balloc.c
>> @@ -2091,7 +2091,8 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>>   	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
>>   	int ret = 0;
>>
>> -	start = range->start>>  sb->s_blocksize_bits;
>> +	start = (range->start>>  sb->s_blocksize_bits) +
>> +		le32_to_cpu(es->s_first_data_block);
>>   	len = range->len>>  sb->s_blocksize_bits;
>>   	minlen = range->minlen>>  sb->s_blocksize_bits;
>>   	trimmed = 0;
>> @@ -2100,10 +2101,6 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>>   		return -EINVAL;
>>   	if (start>= max_blks)
>>   		goto out;
>> -	if (start<  le32_to_cpu(es->s_first_data_block)) {
>> -		len -= le32_to_cpu(es->s_first_data_block) - start;
>> -		start = le32_to_cpu(es->s_first_data_block);
>> -	}
>>   	if (start + len>  max_blks)
>>   		len = max_blks - start;
>>
>>
> Hi,
>
> Thanks for this patch, I was going to do this, but I am quite busy right
> now. Can you do it for ext4 as well ?
yes, I will send another patch for ext4.

Regards,
Tao
