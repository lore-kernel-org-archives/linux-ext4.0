Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878C9C12002
	for <linux-ext4@archiver.kernel.org>; Sat, 17 Jul 2021 03:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D99861357
	for <linux-ext4@archiver.kernel.org>; Sat, 17 Jul 2021 03:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhGQDNE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 16 Jul 2021 23:13:04 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11327 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbhGQDND (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jul 2021 23:13:03 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GRXzb4bhnz7tCn;
        Sat, 17 Jul 2021 11:05:31 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 17 Jul 2021 11:10:02 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 17
 Jul 2021 11:10:02 +0800
Subject: Re: [PATCH v2 04/12] ss_add_info_dir: fix memory leak and check
 whether
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        wuguanghao <wuguanghao3@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <artem.blagodarenko@gmail.com>,
        <linfeilong@huawei.com>
References: <20210630082724.50838-2-wuguanghao3@huawei.com>
 <20210630082724.50838-5-wuguanghao3@huawei.com> <YPD8sGirl9D/3CyL@mit.edu>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <b8b0f4a0-865c-ce58-4382-b330fa5f53d7@huawei.com>
Date:   Sat, 17 Jul 2021 11:10:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YPD8sGirl9D/3CyL@mit.edu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On 2021/7/16 11:27, Theodore Y. Ts'o wrote:
> On Wed, Jun 30, 2021 at 04:27:16PM +0800, wuguanghao wrote:
>> In ss_add_info_dir(), need free info->info_dirs before return,
>> otherwise it will cause memory leak. At the same time, it is necessary
>> to check whether dirs[n_dirs] is a null pointer, otherwise a segmentation
>> fault will occur.
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> Reviewed-by: Wu Bo <wubo40@huawei.com>
>> ---
>>  lib/ss/help.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/lib/ss/help.c b/lib/ss/help.c
>> index 5204401b..6768b9b1 100644
>> --- a/lib/ss/help.c
>> +++ b/lib/ss/help.c
>> @@ -148,6 +148,7 @@ void ss_add_info_dir(int sci_idx, char *info_dir, int *code_ptr)
>>      dirs = (char **)realloc((char *)dirs,
>>  			    (unsigned)(n_dirs + 2)*sizeof(char *));
>>      if (dirs == (char **)NULL) {
>> +	free(info->info_dirs);
>>  	info->info_dirs = (char **)NULL;
>>  	*code_ptr = errno;
>>  	return;
> Adding the free() isn't right fix.  The real problem is that this line
> should be removed:
>
>   	info->info_dirs = (char **)NULL;
>
> The function is trying to add a string (a directory name) to list, and
> the realloc() is trying to extend the list.  If the realloc fils, we
> shouldn't be zapping the original list.  We should just be returning,
> and leaving the original list of directories unchanged and untouched.
>
>     	    		      	 	     - Ted

Thanks for your patient reply.

We will correct that in v3 patch.

>
> .

