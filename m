Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714A7C77B73
	for <linux-ext4@archiver.kernel.org>; Fri, 21 Apr 2023 01:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjDUBws (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 20 Apr 2023 21:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjDUBwr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Apr 2023 21:52:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA860172C;
        Thu, 20 Apr 2023 18:52:39 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q2cqw3rH1zSmkt;
        Fri, 21 Apr 2023 09:48:28 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 09:52:37 +0800
Subject: Re: [PATCH] ext4: Fix unused iterator variable warnings
To:     Nathan Chancellor <nathan@kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>
CC:     <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230420-ext4-unused-variables-super-c-v1-1-138b6db6c21c@kernel.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <d889cae1-8b16-3a2b-49b5-0f649e59f339@huawei.com>
Date:   Fri, 21 Apr 2023 09:52:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230420-ext4-unused-variables-super-c-v1-1-138b6db6c21c@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2023/4/21 0:51, Nathan Chancellor wrote:
> When CONFIG_QUOTA is disabled, there are warnings around unused iterator
> variables:
> 
>    fs/ext4/super.c: In function 'ext4_put_super':
>    fs/ext4/super.c:1262:13: error: unused variable 'i' [-Werror=unused-variable]
>     1262 |         int i, err;
>          |             ^
>    fs/ext4/super.c: In function '__ext4_fill_super':
>    fs/ext4/super.c:5200:22: error: unused variable 'i' [-Werror=unused-variable]
>     5200 |         unsigned int i;
>          |                      ^
>    cc1: all warnings being treated as errors
> 
> The kernel has updated to gnu11, allowing the variables to be declared
> within the for loop. Do so to clear up the warnings.
> 
> Fixes: dcbf87589d90 ("ext4: factor out ext4_flex_groups_free()")
> Signed-off-by: Nathan Chancellor<nathan@kernel.org>
> ---
>   fs/ext4/super.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)

Thanks for the fix:

Reviewed-by: Jason Yan <yanaijie@huawei.com>
