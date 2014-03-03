From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: Re: [PATCH] ext3: fix some wrong comments
Date: Mon, 3 Mar 2014 09:44:02 +0800
Message-ID: <5313DE62.9050802@huawei.com>
References: <53100429.3000205@huawei.com> <53103ABB.9030100@huawei.com> <20140228083710.GC28074@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:37209 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaCCBo1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 20:44:27 -0500
In-Reply-To: <20140228083710.GC28074@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/2/28 16:37, Jan Kara wrote:
> On Fri 28-02-14 15:28:59, ZhangZhen wrote:
>> The comments in the code are wrong, because every generic_file_write=
()
>> is replaced by generic_file_aio_write().
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>> ---
>>  fs/ext3/inode.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
>> index 384b6eb..0b94832 100644
>> --- a/fs/ext3/inode.c
>> +++ b/fs/ext3/inode.c
>> @@ -1574,7 +1574,7 @@ static int buffer_unmapped(handle_t *handle, s=
truct buffer_head *bh)
>>   *
>>   * Similar for:
>>   *
>> - *	ext3_file_write() -> generic_file_write() -> __alloc_pages() -> =
=2E..
>> + *	ext3_file_write() -> generic_file_aio_write() -> __alloc_pages()=
 -> ...
>   Well, but ext3_file_write() doesn't exist either so the comment obv=
iously
> needs further updates.
>=20
>>   *
>>   * Same applies to ext3_get_block().  We will deadlock on various t=
hings like
>>   * lock_journal and i_truncate_mutex.
>> @@ -3212,7 +3212,7 @@ out_brelse:
>>   *
>>   * We are called from a few places:
>>   *
>> - * - Within generic_file_write() for O_SYNC files.
>> + * - Within generic_file_aio_write() for O_SYNC files.
>>   *   Here, there will be no transaction running. We wait for any ru=
nning
>>   *   transaction to commit.
>>   *
>   This is correct but as I'm looking through the comment it needs muc=
h
> larger update. So something like attached patches looks more appropri=
ate.
> Thanks for pointing me to those outdated comments.
>=20
> 								Honza
>=20
Hi Honza=EF=BC=8C
=09
Your fix is more better than mine. It's a good chance for me to learn, =
thanks!

								Zhen

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
