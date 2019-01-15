Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:48004 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728679AbfAOMqO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 15 Jan 2019 07:46:14 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 442FF77D4041247AAAD9
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 20:46:12 +0800 (CST)
Subject: Re: [PATCH] ext2: add check for blocksize in ext2_fill_super
To: Jan Kara <jack@suse.cz>
CC: <linux-ext4@vger.kernel.org>, <miaoxie@huawei.com>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>
References: <20190110053145.138518-1-yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
Message-ID: <422fbc79-12a1-62d4-ee4a-0bc9b652cd89@huawei.com>
Date: Tue, 15 Jan 2019 20:46:01 +0800
MIME-Version: 1.0
In-Reply-To: <20190110053145.138518-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan Kara,

Could you please help me to check this patch?

Besides, i have notice that EXT2_MAX_BLOCK_SIZE has never been used 
before. So there maybe someone using ext2fs which blocksize exceed 
EXT2_MAX_BLOCK_SIZE in the os that page size exceed 4K? And if it's 
true, this patch will lead to a unused ext2fs.

Also, we can fix the problem by modify ext2_max_size, but it's difficult 
to get the accurate result, it may not a good idea too...

Thanks a lot,
Kun.


yangerkun wrote on 2019/1/10 13:31:
> While mkfs with '-b 65536' and then mount this fs with arm 64KB page
> size, function mount_fs will trigger WARNING because that ext2_max_size
> will return value less than 0. Also, we cannot write any file in this
> fs since the sb->s_maxbytes is less than 0. Avoid this by check blocksize
> in ext2_fill_super like ext4_fill_super.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>   fs/ext2/ext2.h  |  1 +
>   fs/ext2/super.c | 15 +++++++++++++++
>   2 files changed, 16 insertions(+)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index e770cd1..ba95316 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -177,6 +177,7 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
>   #define EXT2_MIN_BLOCK_SIZE		1024
>   #define	EXT2_MAX_BLOCK_SIZE		4096
>   #define EXT2_MIN_BLOCK_LOG_SIZE		  10
> +#define EXT2_MAX_BLOCK_LOG_SIZE		  12
>   #define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
>   #define	EXT2_ADDR_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (__u32))
>   #define EXT2_BLOCK_SIZE_BITS(s)		((s)->s_blocksize_bits)
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 73b2d52..029945e 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -960,6 +960,21 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>   	}
>   
>   	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
> +	if (blocksize < EXT2_MIN_BLOCK_SIZE ||
> +		blocksize > EXT2_MAX_BLOCK_SIZE) {
> +		ext2_msg(sb, KERN_ERR,
> +				"Unsupported filesystem blocksize %d (%d log_block_size)",
> +				blocksize, le32_to_cpu(es->s_log_block_size));
> +		goto failed_mount;
> +	}
> +
> +	if (le32_to_cpu(es->s_log_block_size) >
> +		(EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE)) {
> +			ext2_msg(sb, KERN_ERR,
> +				"Invalid log block size: %u",
> +				le32_to_cpu(es->s_log_block_size));
> +			goto failed_mount;
> +		}
>   
>   	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
>   		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
> 
