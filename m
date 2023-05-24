Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393DDC77B7A
	for <linux-ext4@archiver.kernel.org>; Wed, 24 May 2023 06:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbjEXGTC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 May 2023 02:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239690AbjEXGS4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 May 2023 02:18:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B419C196;
        Tue, 23 May 2023 23:18:43 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QR19H4wyqzqTNC;
        Wed, 24 May 2023 14:14:11 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 14:18:40 +0800
Message-ID: <0689edcf-8b7b-a86f-c672-3340c6e8e5e2@huawei.com>
Date:   Wed, 24 May 2023 14:18:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v3 0/2] ext4: fix quotas leak in __ext4_fill_super()
Content-Language: en-US
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
        <yukuai3@huawei.com>, Baokun Li <libaokun1@huawei.com>
References: <20230327141630.156875-1-libaokun1@huawei.com>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <20230327141630.156875-1-libaokun1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

A gentle ping.

On 2023/3/27 22:16, Baokun Li wrote:
> V1->V2:
> 	Add judgment for CONFIG_QUOTA to avoid warning
> 	"label 'failed_mount9' defined but not used".
> 	(Reported-by: kernel test robot <lkp@intel.com>)
> V2->V3:
> 	By adding __maybe_unused to silence possible compilation
> 	complain in patch one, instead of adding the judgment.
> 	(Suggested by Jan Kara).
>
> Baokun Li (2):
>    ext4: turning quotas off if mount failed after enable quotas
>    ext4: refactoring to use the unified helper ext4_quotas_off()
>
>   fs/ext4/super.c | 30 ++++++++++--------------------
>   1 file changed, 10 insertions(+), 20 deletions(-)
>

