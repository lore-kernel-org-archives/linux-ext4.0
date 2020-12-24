Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D941FC433DB
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Dec 2020 01:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9291722571
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Dec 2020 01:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgLXB5W (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Dec 2020 20:57:22 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41023 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726288AbgLXB5W (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Dec 2020 20:57:22 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BO1tjeZ014478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 20:55:46 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E7142420280; Wed, 23 Dec 2020 20:55:44 -0500 (EST)
Date:   Wed, 23 Dec 2020 20:55:44 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ext4: use DEFINE_MUTEX (and mutex_init() had been
 too late)
Message-ID: <X+P1IKbjELeomyeo@mit.edu>
References: <20201223141254.559-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223141254.559-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 23, 2020 at 10:12:54PM +0800, Zheng Yongjun wrote:
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Why is mutex_init() too late?  We only take the mutex after we
mounting an ext4 file system, and that can't happen until ext4_init_fs
is called.

					- Ted

>  fs/ext4/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 94472044f4c1..8776f06a639d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -59,7 +59,7 @@
>  #include <trace/events/ext4.h>
>  
>  static struct ext4_lazy_init *ext4_li_info;
> -static struct mutex ext4_li_mtx;
> +static DEFINE_MUTEX(ext4_li_mtx);
>  static struct ratelimit_state ext4_mount_msg_ratelimit;
>  
>  static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
> @@ -6640,7 +6640,6 @@ static int __init ext4_init_fs(void)
>  
>  	ratelimit_state_init(&ext4_mount_msg_ratelimit, 30 * HZ, 64);
>  	ext4_li_info = NULL;
> -	mutex_init(&ext4_li_mtx);
>  
>  	/* Build-time check for flags consistency */
>  	ext4_check_flag_values();
> -- 
> 2.22.0
> 
