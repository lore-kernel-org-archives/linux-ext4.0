Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F93C61DA4
	for <linux-ext4@archiver.kernel.org>; Thu,  9 Feb 2023 09:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjBIJCS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjBIJCQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Feb 2023 04:02:16 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B23113FD;
        Thu,  9 Feb 2023 01:02:07 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PC9mQ4Gn3z16NXH;
        Thu,  9 Feb 2023 16:59:50 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 9 Feb 2023 17:02:02 +0800
Message-ID: <ee4a4029-4fab-3147-8837-72f2a52c745b@huawei.com>
Date:   Thu, 9 Feb 2023 17:02:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] ext4: Add default commit interval test
Content-Language: en-US
To:     <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <lczerner@redhat.com>
References: <20230118052549.4068332-1-wangjianjian3@huawei.com>
From:   "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <20230118052549.4068332-1-wangjianjian3@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.234.194]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

any comments?
