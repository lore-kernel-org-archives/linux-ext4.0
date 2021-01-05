Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA83C433DB
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Jan 2021 05:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87EB1229C4
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Jan 2021 05:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbhAEF6w (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Jan 2021 00:58:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10020 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbhAEF6v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jan 2021 00:58:51 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D91wq0pTVzj3p6;
        Tue,  5 Jan 2021 13:57:15 +0800 (CST)
Received: from [10.174.176.235] (10.174.176.235) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 13:58:00 +0800
Subject: Re: [PATCH v2] ext4: fix bug for rename with RENAME_WHITEOUT
To:     Jan Kara <jack@suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <yi.zhang@huawei.com>,
        <lihaotian9@huawei.com>, <lutianxiong@huawei.com>,
        <linfeilong@huawei.com>
References: <20201229090208.1113218-1-yangerkun@huawei.com>
 <20210104141953.GF4018@quack2.suse.cz>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <b2829aa0-7c7e-077f-3b89-7c3b8fe7b3f9@huawei.com>
Date:   Tue, 5 Jan 2021 13:58:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210104141953.GF4018@quack2.suse.cz>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.235]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



ÔÚ 2021/1/4 22:19, Jan Kara Ð´µÀ:
> On Tue 29-12-20 17:02:08, yangerkun wrote:
>> ext4_rename will create a special inode for whiteout and use this 'ino'
>> to replace the source file's dir entry 'ino'. Once error happens
>> latter(small ext4 img, and consume all space, so the rename with dst
>> path not exist will fail due to the ENOSPC return from ext4_add_entry in
>> ext4_rename), the cleanup do drop the nlink for whiteout, but forget to
>> restore 'ino' with source file. This will lead to "deleted inode
>> referenced".
>>
>> Signed-off-by: yangerkun <yangerkun@huawei.com>
> 
> Thanks for the patch! It looks mostly good, just one comment below:
> 
>>   end_rename:
>> -	brelse(old.dir_bh);
>> -	brelse(old.bh);
>> -	brelse(new.bh);
>>   	if (whiteout) {
>> +		ext4_setent(handle, &old,
>> +			    old.inode->i_ino, old_file_type);
> 
> I'm wondering here - how is it correct to reset the 'old' entry whenever
> whiteout != NULL? I'd expect this to be guarded by the if (retval) check...

Thanks a lot! This is actually a bug and sorry for that. We need check
retval to prevent call for ext4_setent for the correct case. I will
resend the patch!

> 
> 									Honza
> 
>>   		if (retval)
>>   			drop_nlink(whiteout);
>>   		unlock_new_inode(whiteout);
>>   		iput(whiteout);
>>   	}
>> +	brelse(old.dir_bh);
>> +	brelse(old.bh);
>> +	brelse(new.bh);
>>   	if (handle)
>>   		ext4_journal_stop(handle);
>>   	return retval;
>> -- 
>> 2.25.4
>>
