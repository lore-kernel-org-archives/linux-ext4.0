Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D94EC2B9F8
	for <linux-ext4@archiver.kernel.org>; Tue, 25 May 2021 11:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE6D6142B
	for <linux-ext4@archiver.kernel.org>; Tue, 25 May 2021 11:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhEYL1z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 25 May 2021 07:27:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:4002 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhEYL1y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2021 07:27:54 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FqBY93HVvzmb5R
        for <linux-ext4@vger.kernel.org>; Tue, 25 May 2021 19:23:57 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 19:26:17 +0800
Received: from [10.174.179.184] (10.174.179.184) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 19:26:17 +0800
Subject: Re: [PATCH 06/12] append_pathname: check the value returned by
 realloc to avoid segfault
To:     =?UTF-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?= 
        <artem.blagodarenko@gmail.com>
CC:     <linux-ext4@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>
References: <266bc52e-e279-ce84-0e1f-1405b9bc6174@huawei.com>
 <07fe127f-3814-7d12-dea6-b84d9ab4410e@huawei.com>
 <1979B168-38E8-4D35-B8D7-2D47D04ED344@gmail.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
Message-ID: <596fa726-b44e-05eb-02ac-7936cc3cc9fa@huawei.com>
Date:   Tue, 25 May 2021 19:26:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <1979B168-38E8-4D35-B8D7-2D47D04ED344@gmail.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.184]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello Artem Blagodarenko,

Thank you for your review, it should be chdir instead of chadir,
I will modify it in the v2 version. Next time I will take care not to make similar mistakes.
Thanks a lot.

Thanks,
Best regards,
Wu Guanghao

ÔÚ 2021/5/25 17:37, §¢§Ý§Ñ§Ô§à§Õ§Ñ§â§Ö§ß§Ü§à §¡§â§ä§×§Þ Ð´µÀ:
> Hello Wu,
> 
> Thanks for the patch.
> 
>> On 24 May 2021, at 14:23, Wu Guanghao <wuguanghao3@huawei.com> wrote:
>>
>> In append_pathname(), we need to add a new path to save the value returned by realloc,
>> otherwise the name->path may be NULL, causing segfault
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> ---
>> contrib/fsstress.c | 10 ++++++++--
>> 1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/contrib/fsstress.c b/contrib/fsstress.c
>> index 2a983482..530bd920 100644
>> --- a/contrib/fsstress.c
>> +++ b/contrib/fsstress.c
>> @@ -599,7 +599,7 @@ void add_to_flist(int ft, int id, int parent)
>> void append_pathname(pathname_t * name, char *str)
>> {
>> 	int len;
>> -
>> +	char *path;:
>> 	len = strlen(str);
>> #ifdef DEBUG
>> 	if (len && *str == '/' && name->len == 0) {
>> @@ -609,7 +609,13 @@ void append_pathname(pathname_t * name, char *str)
>>
>> 	}
>> #endif
>> -	name->path = realloc(name->path, name->len + 1 + len);
>> +	path = realloc(name->path, name->len + 1 + len);
>> +	if (path == NULL) {
>> +		fprintf(stderr, "fsstress: append_pathname realloc failed\n");
>> +		chadir(homedir);
> 
> Did you mean chdir() here?
> 
>> +		abort();
>> +	}
>> +	name->path = path;
>> 	strcpy(&name->path[name->len], str);
>> 	name->len += len;
>> }
>> -- 
> 
> 
> Thanks,
> Best regards,
> Artem Blagodarenko.
> 
> .
> 
