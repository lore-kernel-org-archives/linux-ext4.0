Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B990AC6377A
	for <linux-ext4@archiver.kernel.org>; Sat, 17 Jul 2021 01:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 912BE613F3
	for <linux-ext4@archiver.kernel.org>; Sat, 17 Jul 2021 01:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhGQBnN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 16 Jul 2021 21:43:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7380 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhGQBm5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jul 2021 21:42:57 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GRW0l6NH0z7v44;
        Sat, 17 Jul 2021 09:36:23 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 17 Jul 2021 09:39:59 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 17
 Jul 2021 09:39:59 +0800
Subject: Re: [PATCH v2 11/12] misc/lsattr: check whether path is NULL in
 lsattr_dir_proc()
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        wuguanghao <wuguanghao3@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <artem.blagodarenko@gmail.com>,
        <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>
References: <20210630082724.50838-2-wuguanghao3@huawei.com>
 <20210630082724.50838-12-wuguanghao3@huawei.com> <YPED9XnrrHFaC11p@mit.edu>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <08a0c82a-9771-3b9e-04a8-4cede7d5d576@huawei.com>
Date:   Sat, 17 Jul 2021 09:39:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YPED9XnrrHFaC11p@mit.edu>
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


On 2021/7/16 11:58, Theodore Y. Ts'o wrote:
> On Wed, Jun 30, 2021 at 04:27:23PM +0800, wuguanghao wrote:
>> diff --git a/misc/lsattr.c b/misc/lsattr.c
>> index 0d954376..f3212069 100644
>> --- a/misc/lsattr.c
>> +++ b/misc/lsattr.c
>> @@ -144,6 +144,12 @@ static int lsattr_dir_proc (const char * dir_name, struct dirent * de,
>>  	int dir_len = strlen(dir_name);
>>  
>>  	path = malloc(dir_len + strlen (de->d_name) + 2);
>> +	if (!path) {
>> +		fprintf(stderr, "%s",
>> +			_("Couldn't allocate path variable "
>> +			  "in lsattr_dir_proc"));
>> +		return -1;
>> +	}
> The string is missing a closing newline.  Also, why not?
>
> 		fputs(_("Couldn't allocate path variable in lsattr_dir_proc"),
> 		      stderr);
>
> 					- Ted
>
> .

Thanks for your suggestion.

We will resend the v3 patch as your suggestion.



