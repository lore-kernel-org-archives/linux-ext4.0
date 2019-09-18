Return-Path: <SRS0=iZ5A=XN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B72C4CEC9
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Sep 2019 01:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E187A206C2
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Sep 2019 01:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfIRBri (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 17 Sep 2019 21:47:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2670 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbfIRBrh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 17 Sep 2019 21:47:37 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0845313B549124C17328;
        Wed, 18 Sep 2019 09:47:36 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Sep 2019
 09:47:25 +0800
Subject: Re: [PATCH] ext4: fix a bug in ext4_wait_for_tail_page_commit
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
CC:     <jack@suse.cz>, <linux-ext4@vger.kernel.org>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>
References: <20190917084814.40370-1-yangerkun@huawei.com>
 <20190917153140.GF6762@mit.edu>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <6e4e2ea3-fd92-0b2c-24d9-60b8d67b07a6@huawei.com>
Date:   Wed, 18 Sep 2019 09:47:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190917153140.GF6762@mit.edu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On 2019/9/17 23:31, Theodore Y. Ts'o wrote:
> On Tue, Sep 17, 2019 at 04:48:14PM +0800, yangerkun wrote:
>> No need to wait when offset equals to 0. And it will trigger a bug since
>> the latter __ext4_journalled_invalidatepage can free the buffers but leave
>> page still dirty.
> That's only true if the block size == the page size, no?  If the
> offset is zero and the block size is 1k, we still need to wait.
> Shouldn't the better fix be:
>
>> -	if (offset > PAGE_SIZE - i_blocksize(inode))
>> +	if (offset >= PAGE_SIZE - i_blocksize(inode))

It can trigger free buffers in 
__ext4_journalled_invalidatepage(offset==0,blocksize=1k), and we will 
see the bug again.

For some other case, like offset==3k blocksize=1k, actually we should 
wait the commit, but now we will return directly.

Thanks.

>    	   	      		- Ted
>
> .
>

