Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE16C43381
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 01:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442C020830
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 01:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfCDBbM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 Mar 2019 20:31:12 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:4764 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726012AbfCDBbM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 3 Mar 2019 20:31:12 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F0BC8533A7EBF971EE40;
        Mon,  4 Mar 2019 09:31:10 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.203) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Mon, 4 Mar 2019
 09:31:07 +0800
Subject: Re: [PATCH] ext4: remove useless ext4_pin_inode()
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
References: <20190227022048.22887-1-yanaijie@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <8ea5a72f-d339-450c-2604-49f730afa43b@huawei.com>
Date:   Mon, 4 Mar 2019 09:31:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190227022048.22887-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Friendly ping...

Anyone can help to review this patch?

On 2019/2/27 10:20, Jason Yan wrote:
> This function is never used from the beginning. Let's remove it.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   fs/ext4/inode.c | 30 ------------------------------
>   1 file changed, 30 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 34d7e0703cc6..0060d08edd92 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6089,36 +6089,6 @@ void ext4_dirty_inode(struct inode *inode, int flags)
>   	return;
>   }
>   
> -#if 0
> -/*
> - * Bind an inode's backing buffer_head into this transaction, to prevent
> - * it from being flushed to disk early.  Unlike
> - * ext4_reserve_inode_write, this leaves behind no bh reference and
> - * returns no iloc structure, so the caller needs to repeat the iloc
> - * lookup to mark the inode dirty later.
> - */
> -static int ext4_pin_inode(handle_t *handle, struct inode *inode)
> -{
> -	struct ext4_iloc iloc;
> -
> -	int err = 0;
> -	if (handle) {
> -		err = ext4_get_inode_loc(inode, &iloc);
> -		if (!err) {
> -			BUFFER_TRACE(iloc.bh, "get_write_access");
> -			err = jbd2_journal_get_write_access(handle, iloc.bh);
> -			if (!err)
> -				err = ext4_handle_dirty_metadata(handle,
> -								 NULL,
> -								 iloc.bh);
> -			brelse(iloc.bh);
> -		}
> -	}
> -	ext4_std_error(inode->i_sb, err);
> -	return err;
> -}
> -#endif
> -
>   int ext4_change_inode_journal_flag(struct inode *inode, int val)
>   {
>   	journal_t *journal;
> 

