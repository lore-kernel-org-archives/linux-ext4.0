Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4B9C6377A
	for <linux-ext4@archiver.kernel.org>; Mon, 19 Jul 2021 11:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F43610F7
	for <linux-ext4@archiver.kernel.org>; Mon, 19 Jul 2021 11:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhGSK1d (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 19 Jul 2021 06:27:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11447 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhGSK1b (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jul 2021 06:27:31 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GSzWf0bHdzcg5l;
        Mon, 19 Jul 2021 19:04:46 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 19:08:05 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 19
 Jul 2021 19:08:05 +0800
Subject: Re: [PATCH v2 05/12] ss_create_invocation: fix memory leak and check
 whether NULL pointer
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        wuguanghao <wuguanghao3@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <artem.blagodarenko@gmail.com>,
        <linfeilong@huawei.com>
References: <20210630082724.50838-2-wuguanghao3@huawei.com>
 <20210630082724.50838-6-wuguanghao3@huawei.com> <YPD+YbH7STaKTgxC@mit.edu>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <63560c80-4519-7cee-f948-4e909f5a2e05@huawei.com>
Date:   Mon, 19 Jul 2021 19:08:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YPD+YbH7STaKTgxC@mit.edu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On 2021/7/16 11:34, Theodore Y. Ts'o wrote:
> On Wed, Jun 30, 2021 at 04:27:17PM +0800, wuguanghao wrote:
>> In ss_create_invocation(), it is necessary to check whether
>> returned by malloc is a null pointer.
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> ---
>>  lib/ss/invocation.c | 38 ++++++++++++++++++++++++++++++++------
>>  1 file changed, 32 insertions(+), 6 deletions(-)
>>
> Instead of adding all of these goto targets (which is fragile if for
> some reason the code gets rearranged), it would be better to make sure
> everything that we might want to free is initialized, i.e.:
>
>   	register ss_data *new_table = NULL;
>   	register ss_data **table = NULL;
>
>   	new_table = (ss_data *) malloc(sizeof(ss_data));
> 	if (!new_table)
> 		goto out;
> 	memset(new_table, 0, sizeof(ss_data));
>
> and then exit path can just look like this:
>
> out:
> 	if (new_table) {
> 		free(new_table->prompt);
> 		free(new_table->info_dirs);
> 	}
> 	free(new_table);
> 	free(table);
> 	*code_ptr = ENOMEM;
> 	return 0;
>
> ... which is much cleaner, and means in the future, you don't need to
> figure out which goto label you might need to jump to.
>
> Cheers,
>
> 					- Ted
>
> P.S.  And if we are making all of these changes to the function's
> initializers, it might be a good time to zap the "register" keywords
> for any lines we are changing, or are nearby, while we're at it.
>
> .

Thanks for your suggestion.

We will rewrite the patch and remove the "register" keywords.


Regards

Zhiqiang Liu

.

