Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6018C6FD1C
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Mar 2023 14:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjCNOh1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Mar 2023 10:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCNOh0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2023 10:37:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5229F079;
        Tue, 14 Mar 2023 07:37:24 -0700 (PDT)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pbbf72tmhzHwk9;
        Tue, 14 Mar 2023 22:35:11 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 22:37:21 +0800
Subject: Re: [PATCH v2 1/5] ext4: Fix reusing stale buffer heads from last
 failed mounting
To:     Jan Kara <jack@suse.cz>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.com>,
        <tudor.ambarus@linaro.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20230313132021.672134-1-chengzhihao1@huawei.com>
 <20230313132021.672134-2-chengzhihao1@huawei.com>
 <20230314113342.74g2pfwe5y7b5poa@quack3>
 <b7d108d6-9e5a-d88a-305d-932e75098b09@huawei.com>
 <20230314121125.tnz22hckcaj46kp6@quack3>
 <f86584f6-3877-ff18-47a1-2efaa12d18b2@huawei.com>
 <20230314142831.75ste5im66rx4mt3@quack3>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <456d5a86-9e5a-6915-bf79-737afe656a2e@huawei.com>
Date:   Tue, 14 Mar 2023 22:37:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20230314142831.75ste5im66rx4mt3@quack3>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


> OK, fair point. But please move this cleanup into a separate commit with
> this justification. Thanks!

OK, I will split it from patch 1 in v3.
