Return-Path: <SRS0=i6rR=SL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E776C282CE
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 13:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E13A3217F4
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 13:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfDINMj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:12:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6717 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727070AbfDINMi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Apr 2019 09:12:38 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 374B09D1F641A5F1B7F6;
        Tue,  9 Apr 2019 21:12:32 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.120) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.408.0; Tue, 9 Apr 2019
 21:12:25 +0800
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Subject: Re: [PATCH] fs/buffer.c: Fix data corruption when buffer write with
 IO error
To:     Jan Kara <jack@suse.cz>
CC:     <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <yi.zhang@huawei.com>
References: <1554534793-31444-1-git-send-email-zhangxiaoxu5@huawei.com>
 <20190408111108.GB18662@quack2.suse.cz>
Message-ID: <cdc7faed-20a0-4024-9405-ab74d7d18ab8@huawei.com>
Date:   Tue, 9 Apr 2019 21:11:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20190408111108.GB18662@quack2.suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.120]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



On 4/8/2019 7:11 PM, Jan Kara wrote:
> On Sat 06-04-19 15:13:13, ZhangXiaoxu wrote:
>> When the buffer write failed, 'end_buffer_write_sync' and
>> 'end_buffer_async_write' will clear the uptodate flag. But the
>> data in the buffer maybe newer than disk. In some case, this
>> will lead data corruption.
>>
>> For example: ext4 flush metadata to disk failed, it will clear
>> the uptodate flag. when a new coming call want the buffer, it will
>> read it from the disk(because the buffer no uptodate flag). But
>> the journal not checkpoint now, it will read old data from disk.
>> If read successfully, ext4 will write the old data to the new
>> journal, the data will corruption.
>>
>> So, don't clear the uptodate flag when write the buffer failed.
>>
>> Signed-off-by: ZhangXiaoxu<zhangxiaoxu5@huawei.com>
> Thanks for the patch. But what are the chances that after the write has
> failed the read will succeed? Also there were places that were using
> buffer_uptodate() to detect IO errors. Did you check all those got
> converted to using buffer_write_io_error() instead?
> 
> 								Honza
> 
I encountered this situation when using iscsi target as the ext4 volume,
if the network down a while when ext4 write metadata to disk, and maybe
read will success after the network recovered.
In my testcase, just create and delete files, when disconnect the network,
the dir entry maybe corruption. I add some logs when read entry buffer from
disk, the buffer stats maybe buffer_write_io_error() and !buffer_uptodate().
In this case, the ext4 will corruption high probability. Because the buffer
is read from disk, and some newer information just on journal. In this case,
we should not read buffer from the disk.

I don't know any other filesystem how to use the uptodate flag. But I think
uptodate means the buffer is valid and newer than disk, am I right?

I just test ext4 use the xfstest.

Any other idea about my problem?





