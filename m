Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B754C433ED
	for <linux-ext4@archiver.kernel.org>; Sat, 24 Apr 2021 04:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E68D561452
	for <linux-ext4@archiver.kernel.org>; Sat, 24 Apr 2021 04:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhDXErL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 24 Apr 2021 00:47:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17052 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhDXErJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Apr 2021 00:47:09 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FRz836CN7z16L2d;
        Sat, 24 Apr 2021 12:44:03 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.216) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Sat, 24 Apr 2021
 12:46:18 +0800
Subject: Re: [PATCH] e2fsprogs: Try again to solve unreliable io case
To:     Theodore Ts'o <tytso@mit.edu>
CC:     Haotian Li <lihaotian9@huawei.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "harshad shirwadkar," <harshadshirwadkar@gmail.com>,
        linfeilong <linfeilong@huawei.com>
References: <d4fd737d-4280-1aee-32ae-36b303e6644d@huawei.com>
 <YH7/D1h5r9WB1TNq@mit.edu> <c1eb6441-9081-530c-63d8-1987048b2011@huawei.com>
 <YILrxJoOA1reNhMq@mit.edu>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <6bc8c1c2-9fff-bef9-c6f3-b2256a4888e1@huawei.com>
Date:   Sat, 24 Apr 2021 12:46:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YILrxJoOA1reNhMq@mit.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.216]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



On 2021/4/23 23:46, Theodore Ts'o wrote:
> On Fri, Apr 23, 2021 at 10:18:09AM +0800, Zhiqiang Liu wrote:
>> Thanks for your reply.
>> Actually, we have met the problem in ipsan situation.
>> When exec 'fsck -a <remote-device>', short-term fluctuations or
>> abnormalities may occur on the network. Despite the driver has
>> do the best effort, some IO errors may occur. So add retrying in
>> e2fsprogs can further improve the reliability of the repair
>> process.
> 
> But why doesn't this happen when the file system is mounted, and why
> is that acceptable?   And why not change the driver to do more retries?
> 
>    		      	      	  - Ted
> 
Actually, this may happen when the filesystem is mounted. The difference
is that the mounted filesystem can ensure the consistency with journal.

For example, if the IO error occurs when calling io_channel_write_byte()
to update superblock, the checksum may be not written to the disk successfully.
Then the checksum error will occur, and the filesystem cannot be
repaired with 'fsck -y|a|f'.

This situation has a very low probability. For improving the reliability of
the repair process, the retries in e2fsprogs may be necessary.

Regards
Zhiqiang Liu.

> .
> 

