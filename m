Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535C2C677F1
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Jan 2023 00:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjASAjF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Jan 2023 19:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjASAjC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jan 2023 19:39:02 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9B2360B5;
        Wed, 18 Jan 2023 16:39:00 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ny3bz1jvXzRrC3;
        Thu, 19 Jan 2023 08:37:03 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 19 Jan 2023 08:38:56 +0800
Message-ID: <28d39a7c-8904-6346-2878-e3e9115e6a39@huawei.com>
Date:   Thu, 19 Jan 2023 08:38:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] ext4: Add default commit interval test
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
CC:     <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>
References: <20230118052515.3966391-1-wangjianjian3@huawei.com>
 <f6b28fd3-1f36-2bb0-aadd-d08b81a64835@huawei.com>
 <20230118160328.qusc5f7h6iwy6tbj@zlang-mailbox>
From:   "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <20230118160328.qusc5f7h6iwy6tbj@zlang-mailbox>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.234.194]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,
ignore those redundant patches.
Sorry for that.
