Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A4EC433B4
	for <linux-ext4@archiver.kernel.org>; Mon, 10 May 2021 03:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722C8610A7
	for <linux-ext4@archiver.kernel.org>; Mon, 10 May 2021 03:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhEJDvz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 9 May 2021 23:51:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2668 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhEJDvz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 9 May 2021 23:51:55 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fdn8C5g9Zz1BHrv;
        Mon, 10 May 2021 11:48:11 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.249) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Mon, 10 May 2021
 11:50:40 +0800
Subject: Re: [PATCH] e2fsck: try write_primary_superblock() again when it
 failed
To:     Haotian Li <lihaotian9@huawei.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
CC:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        linfeilong <linfeilong@huawei.com>
References: <7486f08c-7f14-9fac-fdb2-0fe78a799d90@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <8e16a65d-bca2-c95a-aac5-0ba5411695ed@huawei.com>
Date:   Mon, 10 May 2021 11:50:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7486f08c-7f14-9fac-fdb2-0fe78a799d90@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.249]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

friendly ping...

On 2021/4/13 11:19, Haotian Li wrote:
> Function write_primary_superblock() has two ways to flush
> superblock, byte-by-byte as default. It may use
> io_channel_write_byte() many times. If some errors occur
> during these funcs, the superblock may become inconsistent
> and produce checksum error.
>
> Try write_primary_superblock() with whole-block way again
> when it failed on byte-by-byte way.
> ---
>  lib/ext2fs/closefs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
> index 69cbdd8c..1fc27fb5 100644
> --- a/lib/ext2fs/closefs.c
> +++ b/lib/ext2fs/closefs.c
> @@ -223,10 +223,8 @@ static errcode_t write_primary_superblock(ext2_filsys fs,
>  		retval = io_channel_write_byte(fs->io,
>  			       SUPERBLOCK_OFFSET + (2 * write_idx), size,
>  					       new_super + write_idx);
> -		if (retval == EXT2_ET_UNIMPLEMENTED)
> -			goto fallback;
>  		if (retval)
> -			return retval;
> +			goto fallback;
>  	}
>  	memcpy(fs->orig_super, super, SUPERBLOCK_SIZE);
>  	return 0;

