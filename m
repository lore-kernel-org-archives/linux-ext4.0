Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BEDC282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 12:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ADD220821
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 12:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfBLMmH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:42:07 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:3188 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727763AbfBLMmH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 07:42:07 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 58A379BF77D202D4D28C;
        Tue, 12 Feb 2019 20:42:04 +0800 (CST)
Received: from [127.0.0.1] (10.177.33.43) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.408.0; Tue, 12 Feb 2019
 20:41:54 +0800
Subject: Re: [PATCH] ext4: disallow files with EXT4_JOURNAL_DATA_FL from
 EXT4_IOC_SWAP_BOOT
To:     Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
CC:     <jack@suse.com>, <miaoxie@huawei.com>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>
References: <20190211061537.32386-1-tytso@mit.edu>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <bc382233-35ff-943e-d9f7-b17f9dce193d@huawei.com>
Date:   Tue, 12 Feb 2019 20:41:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190211061537.32386-1-tytso@mit.edu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.33.43]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Reviewed-by: yangerkun <yangerkun@huawei.com>

Theodore Ts'o wrote on 2019/2/11 14:15:
> A malicious/clueless root user can use EXT4_IOC_SWAP_BOOT to force a
> corner casew which can lead to the file system getting corrupted.
> There's no usefulness to allowing this, so just prohibit this case.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>   fs/ext4/ioctl.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 2e76fb55d94a..eb8ca8d80885 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -132,6 +132,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
>   
>   	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
>   	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
> +	    (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL) ||
>   	    ext4_has_inline_data(inode)) {
>   		err = -EINVAL;
>   		goto journal_err_out;
> 

