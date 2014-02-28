From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: Re: [PATCH] ext3/4: remove some unnecessary comments
Date: Fri, 28 Feb 2014 10:46:35 +0800
Message-ID: <530FF88B.5060709@huawei.com>
References: <1393521230-3254-1-git-send-email-zhenzhang.zhang@huawei.com> <530F04B1.40105@huawei.com> <alpine.LFD.2.00.1402271241590.2247@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Li Zefan <lizefan@huawei.com>, <linux-ext4@vger.kernel.org>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:29060 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaB1CrV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Feb 2014 21:47:21 -0500
In-Reply-To: <alpine.LFD.2.00.1402271241590.2247@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/2/27 19:44, Luk=E1=9A Czerner wrote:
> On Thu, 27 Feb 2014, ZhangZhen wrote:
>=20
>> Date: Thu, 27 Feb 2014 17:26:09 +0800
>> From: ZhangZhen <zhenzhang.zhang@huawei.com>
>> To: jack@suse.cz, tytso@mit.edu
>> Cc: linux-ext4@vger.kernel.org
>> Subject: [PATCH] ext3/4: remove some unnecessary comments
>>
>> The comments in the code are unnecessary, because every generic_file=
_write()
>> is replaced by generic_file_aio_write().
>=20
> I am sorry I do not understand. Is it unnecessary or wrong ? If it's
> wrong why it is wrong ?
>=20
> Your description suggests that this should be changed to mention
> generic_file_aio_write() rather than generic_file_write().
>=20
> Thanks!
> -Lukas
>=20
Thanks for reviewing!

Here should be changed to mention generic_file_aio_write() rather than
generic_file_write().

I will modify this patch for V2.
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>> ---
>>  fs/ext3/inode.c | 4 ----
>>  fs/ext4/inode.c | 4 ----
>>  2 files changed, 8 deletions(-)
>>
>> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
>> index 384b6eb..e08c2eb 100644
>> --- a/fs/ext3/inode.c
>> +++ b/fs/ext3/inode.c
>> @@ -3212,10 +3212,6 @@ out_brelse:
>>   *
>>   * We are called from a few places:
>>   *
>> - * - Within generic_file_write() for O_SYNC files.
>> - *   Here, there will be no transaction running. We wait for any ru=
nning
>> - *   transaction to commit.
>> - *
>>   * - Within sys_sync(), kupdate and such.
>>   *   We wait on commit, if tol to.
>>   *
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 6e39895..5ef32f0 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4399,10 +4399,6 @@ out_brelse:
>>   *
>>   * We are called from a few places:
>>   *
>> - * - Within generic_file_write() for O_SYNC files.
>> - *   Here, there will be no transaction running. We wait for any ru=
nning
>> - *   transaction to commit.
>> - *
>>   * - Within sys_sync(), kupdate and such.
>>   *   We wait on commit, if tol to.
>>   *
>>
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
