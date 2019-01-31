Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CE6C169C4
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 11:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CB0D2087F
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 11:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbfAaLnm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:43:42 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:53028 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728067AbfAaLnm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Jan 2019 06:43:42 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6D57FF8971B3E28DE0AB
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2019 19:43:40 +0800 (CST)
Received: from [127.0.0.1] (10.177.33.43) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.408.0; Thu, 31 Jan 2019
 19:43:29 +0800
Subject: Re: [PATCH 2/2] ext2: get the exact max filesize in ext2_max_size
To:     Jan Kara <jack@suse.cz>
CC:     <miaoxie@huawei.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <linux-ext4@vger.kernel.org>
References: <20190123131409.126156-1-yangerkun@huawei.com>
 <20190123131409.126156-3-yangerkun@huawei.com>
 <20190129164208.GF29981@quack2.suse.cz>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <9d3439c1-1238-fd67-eb3d-8e4fae3e0cd7@huawei.com>
Date:   Thu, 31 Jan 2019 19:42:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190129164208.GF29981@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.33.43]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



Jan Kara wrote on 2019/1/30 0:42:
> On Wed 23-01-19 21:14:09, yangerkun wrote:
>> When mkfs.ext2 with '-b 65536' and mount(arm 64KB page size), function
>> mount_fs will trigger WARNING since ext2_max_size will return value less
>> than 0. Also, we cannot write any file in this fs since the sb->maxbytes
>> is less than 0.
>>
>> Fix it by get the exact max file size. First, get the max depth for
>> indirect blocks and check does the max data blocks add indirect blocks
>> will execced upper_limit. If right, bisect to get exact data blocks
>> number which satisfy 'data blocks number + indirect blocks number ==
>> upper_limit'.
>>
>> Signed-off-by: yangerkun <yangerkun@huawei.com>
> 
> Thanks for the patches but I was really looking for something simpler.
> Something like the attached patch. Although your more precise function will
> raise the maximum file size by couple of kilobytes I don't think the
> complexity is really worth it...

Agree with you. A precise answer with so complexity function does not 
make sense. Also i have review and test your without any problem. I 
prefer your patch!

Reviewed-by: yangerkun <yangerkun@huawei.com>

Thanks a lot,
Kun.

> 
> 								Honza
> 
>> ---
>>   fs/ext2/super.c | 115 ++++++++++++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 92 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
>> index 73b2d52..b3eb6e9 100644
>> --- a/fs/ext2/super.c
>> +++ b/fs/ext2/super.c
>> @@ -753,11 +753,16 @@ static int ext2_check_descriptors(struct super_block *sb)
>>    * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
>>    * We need to be 1 filesystem block less than the 2^32 sector limit.
>>    */
>> -static loff_t ext2_max_size(int bits)
>> +static loff_t ext2_max_size(struct super_block *sb, int bits)
>>   {
>> -	loff_t res = EXT2_NDIR_BLOCKS;
>> -	int meta_blocks;
>> +	loff_t res;
>> +	loff_t max_meta_blocks;
>> +	loff_t used_data_blocks;
>> +	loff_t max_data_blocks;
>>   	loff_t upper_limit;
>> +	int depth;
>> +	loff_t high, low;
>> +
>>   
>>   	/* This is calculated to be the largest file size for a
>>   	 * dense, file such that the total number of
>> @@ -771,24 +776,88 @@ static loff_t ext2_max_size(int bits)
>>   	/* total blocks in file system block size */
>>   	upper_limit >>= (bits - 9);
>>   
>> +	/* Try to get max depth of metadata blocks */
>> +	depth = 0;
>> +	max_meta_blocks = 0;
>> +	used_data_blocks = 0;
>> +	max_data_blocks = EXT2_NDIR_BLOCKS;
>> +	if (max_meta_blocks + max_data_blocks > upper_limit)
>> +		goto bisect;
>> +
>> +	depth++;
>> +	max_meta_blocks = 1;
>> +	used_data_blocks = max_data_blocks;
>> +	max_data_blocks += 1LL << (bits - 2);
>> +	if (max_meta_blocks + max_data_blocks > upper_limit)
>> +		goto bisect;
>> +
>> +	depth++;
>> +	max_meta_blocks += 1 + (1LL << (bits - 2));
>> +	used_data_blocks = max_data_blocks;
>> +	max_data_blocks += 1LL << (2 * (bits - 2));
>> +	if (max_meta_blocks + max_data_blocks > upper_limit)
>> +		goto bisect;
>> +
>> +	depth++;
>> +	max_meta_blocks += 1 + (1LL << (bits - 2)) + (1LL << (2 * (bits - 2)));
>> +	used_data_blocks = max_data_blocks;
>> +	max_data_blocks += 1LL << (3 * (bits - 2));
>> +	if (max_meta_blocks + max_data_blocks > upper_limit)
>> +		goto bisect;
>> +
>> +	goto out;
>> +bisect:
>> +	low = 0;
>> +	if (depth == 0)
>> +		high = EXT2_NDIR_BLOCKS;
>> +	else
>> +		high = 1 << (depth * (bits - 2));
>> +	while (low <= high) {
>> +		int offsets[4];
>> +		loff_t mid = (low + high) >> 1;
>> +		depth = ext2_block_to_path(sb, mid + used_data_blocks - 1, offsets, NULL);
>> +		if (!depth)
>> +			return -EIO;
>> +
>> +		max_meta_blocks = 0;
>> +		if (depth == 1)
>> +			max_meta_blocks = 0;
>> +
>> +		if (depth == 2)
>> +			max_meta_blocks = 1;
>> +
>> +		if (depth == 3) {
>> +			/* Indirect blocks */
>> +			max_meta_blocks += 1;
>> +			/* Double indirect blocks */
>> +			max_meta_blocks += 1;
>> +			max_meta_blocks += offsets[1];
>> +		}
>>   
>> -	/* indirect blocks */
>> -	meta_blocks = 1;
>> -	/* double indirect blocks */
>> -	meta_blocks += 1 + (1LL << (bits-2));
>> -	/* tripple indirect blocks */
>> -	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
>> -
>> -	upper_limit -= meta_blocks;
>> -	upper_limit <<= bits;
>> -
>> -	res += 1LL << (bits-2);
>> -	res += 1LL << (2*(bits-2));
>> -	res += 1LL << (3*(bits-2));
>> -	res <<= bits;
>> -	if (res > upper_limit)
>> -		res = upper_limit;
>> -
>> +		if (depth == 4) {
>> +			/* Indirect blocks */
>> +			max_meta_blocks += 1;
>> +			/* Double indirect blocks */
>> +			max_meta_blocks += 1 + (1 << (bits - 2));
>> +			/* Tripple indirect blocks */
>> +			max_meta_blocks += 1;
>> +			if (offsets[1])
>> +				max_meta_blocks += (offsets[1] - 1) * (1 << (bits - 2));
>> +
>> +			max_meta_blocks += 1;
>> +			max_meta_blocks += offsets[2];
>> +		}
>> +		if (max_meta_blocks + mid + used_data_blocks > upper_limit)
>> +			high = mid - 1;
>> +		if (max_meta_blocks + mid + used_data_blocks < upper_limit)
>> +			low = mid + 1;
>> +		if (max_meta_blocks + mid + used_data_blocks == upper_limit) {
>> +			max_data_blocks = mid + used_data_blocks;
>> +			break;
>> +		}
>> +	}
>> +out:
>> +	res = max_data_blocks << bits;
>>   	if (res > MAX_LFS_FILESIZE)
>>   		res = MAX_LFS_FILESIZE;
>>   
>> @@ -995,7 +1064,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>>   		}
>>   	}
>>   
>> -	sb->s_maxbytes = ext2_max_size(sb->s_blocksize_bits);
>> +	sbi->s_addr_per_block_bits =
>> +		ilog2 (EXT2_ADDR_PER_BLOCK(sb));
>> +	sb->s_maxbytes = ext2_max_size(sb, sb->s_blocksize_bits);
>>   	sb->s_max_links = EXT2_LINK_MAX;
>>   
>>   	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV) {
>> @@ -1035,8 +1106,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>>   					sizeof (struct ext2_group_desc);
>>   	sbi->s_sbh = bh;
>>   	sbi->s_mount_state = le16_to_cpu(es->s_state);
>> -	sbi->s_addr_per_block_bits =
>> -		ilog2 (EXT2_ADDR_PER_BLOCK(sb));
>>   	sbi->s_desc_per_block_bits =
>>   		ilog2 (EXT2_DESC_PER_BLOCK(sb));
>>   
>> -- 
>> 2.9.5
>>

