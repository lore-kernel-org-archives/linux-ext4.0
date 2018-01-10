From: piaojun <piaojun@huawei.com>
Subject: Re: [PATCH] ext4: no need flush workqueue before destroying it
Date: Wed, 10 Jan 2018 08:16:47 +0800
Message-ID: <5A555B6F.7050406@huawei.com>
References: <5A54B7A2.8050101@huawei.com>
 <20180109150712.i5tm3nywi3w4w4rk@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <adilger.kernel@dilger.ca>, <arnd@arndb.de>,
        <linux-ext4@vger.kernel.org>, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752057AbeAJARE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 19:17:04 -0500
In-Reply-To: <20180109150712.i5tm3nywi3w4w4rk@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Thanks for reviewing, and I will resend this patch again.

thanks,
Jun

On 2018/1/9 23:07, Jan Kara wrote:
> On Tue 09-01-18 20:37:54, piaojun wrote:
>> destroy_workqueue() will do flushing work for us.
>>
>> Signed-off-by: Jun Piao <piaojun@huawei.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Adding Ted to CC as a maintainer...
> 
> 								Honza
> 
>> ---
>>  fs/ext4/super.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 0556cd0..2f46b0b 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -870,7 +870,6 @@ static void ext4_put_super(struct super_block *sb)
>>  	ext4_unregister_li_request(sb);
>>  	ext4_quota_off_umount(sb);
>>
>> -	flush_workqueue(sbi->rsv_conversion_wq);
>>  	destroy_workqueue(sbi->rsv_conversion_wq);
>>
>>  	if (sbi->s_journal) {
>> -- 
