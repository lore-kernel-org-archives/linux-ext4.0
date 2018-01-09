From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH] ext4: use strlcpy() instead of strncpy()
Date: Tue, 9 Jan 2018 19:14:36 +0800
Message-ID: <eae3c8fd-d778-fa65-4609-5159a1a3b405@huawei.com>
References: <1515488319-23779-1-git-send-email-wangxiongfeng2@huawei.com>
 <20180109100655.bdbnsrvhceaimaxh@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>,
        <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932219AbeAILOw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 06:14:52 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 46117F29ABAE5
        for <linux-ext4@vger.kernel.org>; Tue,  9 Jan 2018 19:14:38 +0800 (CST)
In-Reply-To: <20180109100655.bdbnsrvhceaimaxh@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 2018/1/9 18:06, Jan Kara wrote:
> On Tue 09-01-18 16:58:39, Xiongfeng Wang wrote:
>> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
>>
>> gcc-8 reports
>>
>> fs/ext4/super.c: In function '__save_error_info.isra.6':
>> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
>> bound 32 equals destination size [-Wstringop-truncation]
>>
>> We need to use strlcpy() to make sure the dest string is nul-terminated.
>>
>> Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> 
> Please have a look how s_last_error_func is used. If you do that, you'll
> notice that we do take care to print only sizeof(s_last_error_func)
> characters from the string or NUL-terminate it (in e2fsprogs). So your
> patch just wastes one character for useless NUL-termination...
> 
> 								Honza

Sorry, I didn't notice how s_last_error_func is used before.
We do waste one character if we use strlcpy() instead of strncpy().
We can't use memcpy() either. But I can't  figure out a better way to avoid
this warning.

Thanks,
Xiongfeng
> 
>> ---
>>  fs/ext4/super.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 7c46693..051b988 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -323,11 +323,11 @@ static void __save_error_info(struct super_block *sb, const char *func,
>>  		return;
>>  	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
>>  	es->s_last_error_time = cpu_to_le32(get_seconds());
>> -	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
>> +	strlcpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
>>  	es->s_last_error_line = cpu_to_le32(line);
>>  	if (!es->s_first_error_time) {
>>  		es->s_first_error_time = es->s_last_error_time;
>> -		strncpy(es->s_first_error_func, func,
>> +		strlcpy(es->s_first_error_func, func,
>>  			sizeof(es->s_first_error_func));
>>  		es->s_first_error_line = cpu_to_le32(line);
>>  		es->s_first_error_ino = es->s_last_error_ino;
>> -- 
>> 1.8.3.1
>>
