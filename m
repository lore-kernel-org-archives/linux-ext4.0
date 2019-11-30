Return-Path: <SRS0=cPVr=ZW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265A9C432C3
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Nov 2019 03:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD1E206E1
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Nov 2019 03:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfK3DZA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Nov 2019 22:25:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6735 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbfK3DZA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Nov 2019 22:25:00 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9375F60AD524312AAD6B;
        Sat, 30 Nov 2019 11:24:58 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.179) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Sat, 30 Nov 2019
 11:24:49 +0800
Subject: Re: [PATCH] ext4, jbd2: ensure panic when there is no need to record
 errno in the jbd2 sb
To:     Jan Kara <jack@suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <jack@suse.com>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <liangyun2@huawei.com>
References: <20191126144537.30020-1-yi.zhang@huawei.com>
 <20191129144611.GA27588@quack2.suse.cz>
From:   "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <0aa529fe-a881-aa4c-3b8f-980c8eceb64b@huawei.com>
Date:   Sat, 30 Nov 2019 11:24:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129144611.GA27588@quack2.suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.179]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2019/11/29 22:46, Jan Kara wrote:
> On Tue 26-11-19 22:45:37, zhangyi (F) wrote:
>> JBD2_REC_ERR flag used to indicate the errno has been updated when jbd2
>> aborted, and then __ext4_abort() and ext4_handle_error() can invoke
>> panic if ERRORS_PANIC is specified. But there is one exception, if jbd2
>> thread failed to submit commit record, it abort journal through
>> invoking __jbd2_journal_abort_hard() without set this flag, so we can
>> no longer panic. Fix this by set such flag even if there is no need to
>> record errno in the jbd2 super block.
>>
>> Fixes: 4327ba52afd03 ("ext4, jbd2: ensure entering into panic after recording an error in superblock")
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> Cc: <stable@vger.kernel.org>
> 
> Thanks for the patch. This indeed looks like a bug. I was trying hard to
> understand why are we actually using __jbd2_journal_abort_hard() in
> fs/jbd2/commit.c in the first place. And after some digging, I think it is
> an oversight and we should just use jbd2_journal_abort(). The calls have been
> introduced by commit 818d276ceb83a "ext4: Add the journal checksum
> feature". Before that commit, we were just using jbd2_journal_abort() when
> writing commit block failed. And when we use jbd2_journal_abort() from
> everywhere, that will also deal with the problem you've found.
> 
> Also as a nice cleanup we could then just drop __jbd2_journal_abort_hard(),
> __jbd2_journal_abort_soft() and have all the functionality in a single
> function jbd2_journal_abort().
>

Indeed, it seems that we also need to record the errno if we failed to
submit commit block, I will remove __jbd2_journal_abort_hard() and combine
them in my next iteration.

Thanks,
Yi.

