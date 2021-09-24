Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27807C433EF
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Sep 2021 09:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037FA6105A
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Sep 2021 09:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245125AbhIXJdz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:33:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:20008 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245092AbhIXJdx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Sep 2021 05:33:53 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HG6C96Rb2zbm3t;
        Fri, 24 Sep 2021 17:28:05 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 17:32:19 +0800
Received: from [10.174.177.210] (10.174.177.210) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 24 Sep 2021 17:32:18 +0800
Message-ID: <206febbd-a00d-de34-d7c6-562aa6c292b5@huawei.com>
Date:   Fri, 24 Sep 2021 17:32:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/3] bugfix for insert/collapse fallocate
To:     <tytso@mit.edu>, <jack@suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <yukuai3@huawei.com>
References: <20210903062748.4118886-1-yangerkun@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
In-Reply-To: <20210903062748.4118886-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.210]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema766-chm.china.huawei.com (10.1.198.208)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

gently ping...

在 2021/9/3 14:27, yangerkun 写道:
> yangerkun (3):
>    ext4: correct the left/middle/right debug message for binsearch
>    ext4: ensure enough credits in ext4_ext_shift_path_extents
>    ext4: stop use path once restart journal in
>      ext4_ext_shift_path_extents
> 
>   fs/ext4/extents.c | 77 ++++++++++++++++++++++-------------------------
>   1 file changed, 36 insertions(+), 41 deletions(-)
> 
