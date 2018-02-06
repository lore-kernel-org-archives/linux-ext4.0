From: Wang Long <wanglong19@meituan.com>
Subject: Re: [PATCH] jbd2: set to NULL after kmem_cache_destroy
Date: Tue, 6 Feb 2018 10:29:40 +0800
Message-ID: <1fb20a12-8482-fea8-1db2-ff764216ea19@meituan.com>
References: <1517837957-1636-1-git-send-email-wanglong19@meituan.com>
 <20180205170006.GA4838@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx-fe5-210.meituan.com ([103.37.138.210]:36007 "EHLO
        mx02.meituan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbeBFC3w (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Feb 2018 21:29:52 -0500
In-Reply-To: <20180205170006.GA4838@magnolia>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 6/2/2018 1:00 AM, Darrick J. Wong wrote:
> On Mon, Feb 05, 2018 at 09:39:17PM +0800, Wang Long wrote:
>> Signed-off-by: Wang Long <wanglong19@meituan.com>
>> ---
>>   fs/jbd2/journal.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 93016bb..38dc24c 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -2649,11 +2649,14 @@ static int __init jbd2_journal_init_handle_cache(void)
>>   
>>   static void jbd2_journal_destroy_handle_cache(void)
>>   {
>> -	if (jbd2_handle_cache)
>> +	if (jbd2_handle_cache) {
>>   		kmem_cache_destroy(jbd2_handle_cache);
> kmem_cache_destroy already handles null pointers, so you can remove the
> conditional test entirely.
>
> --D
Thanks, I will send another patch to remove all conditional test in 
module JBD2.
>> -	if (jbd2_inode_cache)
>> +		jbd2_handle_cache = NULL;
>> +	}
>> +	if (jbd2_inode_cache) {
>>   		kmem_cache_destroy(jbd2_inode_cache);
>> -
>> +		jbd2_inode_cache = NULL;
>> +	}
>>   }
>>   
>>   /*
>> -- 
>> 1.8.3.1
>>
