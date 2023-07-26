Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE17C001B0
	for <linux-ext4@archiver.kernel.org>; Wed, 26 Jul 2023 11:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjGZLTu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 26 Jul 2023 07:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjGZLTt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jul 2023 07:19:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F54497
        for <linux-ext4@vger.kernel.org>; Wed, 26 Jul 2023 04:19:48 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R9rvp6zf6zLnsR;
        Wed, 26 Jul 2023 19:17:10 +0800 (CST)
Received: from [10.174.176.34] (10.174.176.34) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 19:19:45 +0800
Subject: Re: [PATCH] jbd2: Remove unused t_handle_lock
To:     Wang Jianjian <wangjianjian0@foxmail.com>,
        <linux-ext4@vger.kernel.org>
References: <tencent_CB3115278E9ED6BD081097E5753433452107@qq.com>
From:   Zhang Yi <yi.zhang@huawei.com>
Message-ID: <8138c559-325c-a4e3-1018-ca76ba185081@huawei.com>
Date:   Wed, 26 Jul 2023 19:19:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <tencent_CB3115278E9ED6BD081097E5753433452107@qq.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.34]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2023/7/24 22:58, Wang Jianjian wrote:
> Since commit 4f98186848('jbd2: refactor wait logic for transaction
> updates into a common function'), this lock has been no use.

Hi, I don't think the commit is correct, it should be
f7f497cb7024 ("jbd2: kill t_handle_lock transaction spinlock").

Thanks,
Yi.

> ---
>  include/linux/jbd2.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index d860499e15e4..8199235dbaf3 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -636,11 +636,6 @@ struct transaction_s
>  	 */
>  	struct list_head	t_inode_list;
>  
> -	/*
> -	 * Protects info related to handles
> -	 */
> -	spinlock_t		t_handle_lock;
> -
>  	/*
>  	 * Longest time some handle had to wait for running transaction
>  	 */
> 
