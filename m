Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186EAC282C3
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 12:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7A8820870
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 12:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbfAVMaT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:30:19 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:2210 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728239AbfAVMaT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Jan 2019 07:30:19 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 17E74E062DB47665E734
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2019 20:30:17 +0800 (CST)
Received: from [127.0.0.1] (10.177.33.43) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.408.0; Tue, 22 Jan 2019
 20:30:10 +0800
Subject: Re: [PATCH] ext2: add check for blocksize in ext2_fill_super
To:     Jan Kara <jack@suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <miaoxie@huawei.com>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>
References: <20190110053145.138518-1-yangerkun@huawei.com>
 <422fbc79-12a1-62d4-ee4a-0bc9b652cd89@huawei.com>
 <20190122111700.GD13149@quack2.suse.cz>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <14606c49-e010-e624-0009-a2d95d7a8ef7@huawei.com>
Date:   Tue, 22 Jan 2019 20:29:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122111700.GD13149@quack2.suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.33.43]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



Jan Kara wrote on 2019/1/22 19:17:
> Hello!
> 
> On Tue 15-01-19 20:46:01, yangerkun wrote:
>> Could you please help me to check this patch?
>>
>> Besides, i have notice that EXT2_MAX_BLOCK_SIZE has never been used before.
>> So there maybe someone using ext2fs which blocksize exceed
>> EXT2_MAX_BLOCK_SIZE in the os that page size exceed 4K? And if it's true,
>> this patch will lead to a unused ext2fs.
>>
>> Also, we can fix the problem by modify ext2_max_size, but it's difficult to
>> get the accurate result, it may not a good idea too...
> 
> Thanks for your report and the patch! Ext2 is supposed to be usable for
> block sizes between 1k and min(PAGE_SIZE, 64k). So rather than limiting
> block size to 4k, we should fix ext2_max_size(). Will you send a new patch
> or should I fix the problem? I agree it is difficult to come up with the
> exact limit for a particular block size. But the computation does not have
> to be exact - even the current one is not. It just has to be approximately
> right and not allow any overflow. And BTW ext4 seems to have the same
> overflow problem in its ext4_max_bitmap_size().
> 
Hi,

Thanks for your reply!

I am working on this problem now, and the patch will coming soon.

Thanks,
Kun.

> 								Honza
> 
>> yangerkun wrote on 2019/1/10 13:31:
>>> While mkfs with '-b 65536' and then mount this fs with arm 64KB page
>>> size, function mount_fs will trigger WARNING because that ext2_max_size
>>> will return value less than 0. Also, we cannot write any file in this
>>> fs since the sb->s_maxbytes is less than 0. Avoid this by check blocksize
>>> in ext2_fill_super like ext4_fill_super.
>>>
>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>> ---
>>>    fs/ext2/ext2.h  |  1 +
>>>    fs/ext2/super.c | 15 +++++++++++++++
>>>    2 files changed, 16 insertions(+)
>>>
>>> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
>>> index e770cd1..ba95316 100644
>>> --- a/fs/ext2/ext2.h
>>> +++ b/fs/ext2/ext2.h
>>> @@ -177,6 +177,7 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
>>>    #define EXT2_MIN_BLOCK_SIZE		1024
>>>    #define	EXT2_MAX_BLOCK_SIZE		4096
>>>    #define EXT2_MIN_BLOCK_LOG_SIZE		  10
>>> +#define EXT2_MAX_BLOCK_LOG_SIZE		  12
>>>    #define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
>>>    #define	EXT2_ADDR_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (__u32))
>>>    #define EXT2_BLOCK_SIZE_BITS(s)		((s)->s_blocksize_bits)
>>> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
>>> index 73b2d52..029945e 100644
>>> --- a/fs/ext2/super.c
>>> +++ b/fs/ext2/super.c
>>> @@ -960,6 +960,21 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>>>    	}
>>>    	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>>> +	if (blocksize < EXT2_MIN_BLOCK_SIZE ||
>>> +		blocksize > EXT2_MAX_BLOCK_SIZE) {
>>> +		ext2_msg(sb, KERN_ERR,
>>> +				"Unsupported filesystem blocksize %d (%d log_block_size)",
>>> +				blocksize, le32_to_cpu(es->s_log_block_size));
>>> +		goto failed_mount;
>>> +	}
>>> +
>>> +	if (le32_to_cpu(es->s_log_block_size) >
>>> +		(EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE)) {
>>> +			ext2_msg(sb, KERN_ERR,
>>> +				"Invalid log block size: %u",
>>> +				le32_to_cpu(es->s_log_block_size));
>>> +			goto failed_mount;
>>> +		}
>>>    	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
>>>    		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
>>>
>>

