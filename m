Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DFEECAAD1
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Sep 2022 07:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiIAH7H (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Sep 2022 03:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiIAH7G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Sep 2022 03:59:06 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756F2EA8A2
        for <linux-ext4@vger.kernel.org>; Thu,  1 Sep 2022 00:59:05 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MJCzl59v8znTkW;
        Thu,  1 Sep 2022 15:56:35 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 15:59:02 +0800
Subject: Re: [PATCH 13/13] ext4: factor out ext4_journal_data_check()
To:     Jan Kara <jack@suse.cz>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <ritesh.list@gmail.com>, <lczerner@redhat.com>,
        <linux-ext4@vger.kernel.org>
References: <20220830120411.2371968-1-yanaijie@huawei.com>
 <20220830120411.2371968-14-yanaijie@huawei.com>
 <20220831120652.rovamxbtt4ibutar@quack3>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <bf93fb03-6765-a243-dddd-9fa0de273f8e@huawei.com>
Date:   Thu, 1 Sep 2022 15:59:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20220831120652.rovamxbtt4ibutar@quack3>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On 2022/8/31 20:06, Jan Kara wrote:
> On Tue 30-08-22 20:04:11, Jason Yan wrote:
>> Factor out ext4_journal_data_check(). No functional change.
>>
>> Signed-off-by: Jason Yan<yanaijie@huawei.com>
>> ---
>>   fs/ext4/super.c | 60 ++++++++++++++++++++++++++++---------------------
>>   1 file changed, 35 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 95e70f0316db..c070d4f5ecc4 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -4910,6 +4910,39 @@ static int ext4_load_and_init_journal(struct super_block *sb,
>>   	return err;
>>   }
>>   
>> +static int ext4_journal_data_check(struct super_block *sb)
> Perhaps name this ext4_journal_data_mode_check()? 

OK.

Thanks.

Otherwise feel free to
> add:
> 
> Reviewed-by: Jan Kara<jack@suse.cz>
