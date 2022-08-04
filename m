Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B768C19F2B
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Aug 2022 08:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiHDIao (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Aug 2022 04:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbiHDIan (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Aug 2022 04:30:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF955D0EA
        for <linux-ext4@vger.kernel.org>; Thu,  4 Aug 2022 01:30:42 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lz22V2HZzzTgTQ;
        Thu,  4 Aug 2022 16:29:22 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 16:30:40 +0800
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 16:30:40 +0800
Message-ID: <c74612b5-ddb9-b945-f580-a525aa169898@huawei.com>
Date:   Thu, 4 Aug 2022 16:30:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
From:   zhanchengbin <zhanchengbin1@huawei.com>
Subject: Re: [BUG] Tune2fs and fuse2fs do not change j_tail_sequence in
 journal superblock
To:     Alexey Lyahkov <alexey.lyashkov@gmail.com>
CC:     Theodore Ts'o <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
        linfeilong <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        <liangyun2@huawei.com>
References: <3d484b33-410a-c912-a776-28767b381f7a@huawei.com>
 <7B06D7B3-B867-4A65-BCE3-3E4BF8D72330@gmail.com>
In-Reply-To: <7B06D7B3-B867-4A65-BCE3-3E4BF8D72330@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.102]
X-ClientProxiedBy: dggpeml500006.china.huawei.com (7.185.36.76) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> Hi
> 
> Thanks for you report.
> Problem much bigger than it. Debugs based code lack many parts of journal handling, including fast commit.
> Journal tag v3, and other.

I think we can solve the current problem first.

> 
> Alex
> 
>> On 2 Aug 2022, at 14:23, zhanchengbin <zhanchengbin1@huawei.com> wrote:

<snip>

>> There are two existing solutions:
>> 1) Add "journal->j_tail_sequence = journal->j_transaction_sequence" in to the
>> recover_ext3_journal in debugfs/journal.c.

I want to use the first solution, do you have any other solutions?

Thanks.

>> 2) There is a timestamp in the commit block, so we can add timestamp check when
>> the log is replayed.
> 
> .
> 
