Return-Path: <SRS0=VAvg=CD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DCCC433DF
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Aug 2020 02:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D0ED204EC
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Aug 2020 02:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHYCLj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 24 Aug 2020 22:11:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10317 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbgHYCLf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Aug 2020 22:11:35 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0FE8D6DC1D0E38E8D415;
        Tue, 25 Aug 2020 10:11:33 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.86) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 25 Aug 2020
 10:11:30 +0800
Subject: Re: [PATCH 0/2] Fix race between do_invalidatepage and
 init_page_buffers
To:     Jan Kara <jack@suse.cz>
References: <20200822082218.2228697-1-yebin10@huawei.com>
 <20200824155143.GH24877@quack2.suse.cz>
CC:     <jack@suse.com>, <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
From:   yebin <yebin10@huawei.com>
Message-ID: <5F447351.6060207@huawei.com>
Date:   Tue, 25 Aug 2020 10:11:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20200824155143.GH24877@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.86]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Your patch certainly can fix the problem with my testcases, but I don't 
think it's
a good way. There are other paths that can call do_invalidatepage , for 
instance
block ioctl to discard and zero_range.

On 2020/8/24 23:51, Jan Kara wrote:
> Hello,
>
> On Sat 22-08-20 16:22:16, Ye Bin wrote:
>> Ye Bin (2):
>>    ext4: Add comment to BUFFER_FLAGS_DISCARD for search code
>>    jbd2: Fix race between do_invalidatepage and init_page_buffers
>>
>>   fs/buffer.c                 | 12 +++++++++++-
>>   fs/jbd2/journal.c           |  7 +++++++
>>   include/linux/buffer_head.h |  2 ++
>>   3 files changed, 20 insertions(+), 1 deletion(-)
> Thanks for the good description of the problem and the analysis. I could
> now easily understand what was really happening on your system. I think the
> problem should be fixed differently through - it is a problem of
> block_write_full_page() that it invalidates buffers while JBD2 is working
> with them. Attached patch should also fix the problem. Can you please test
> whether it fixes your testcase as well? Thanks!
>
> 								Honza


