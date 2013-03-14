From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] Ext2: do not mark_inode_dirty to avoid BUG_ON
Date: Thu, 14 Mar 2013 08:43:10 +0800
Message-ID: <5BFF32A2-A02E-4D1D-94F7-DA0E84F1E6F3@gmail.com>
References: <513EB7DD.3020103@cn.fujitsu.com> <20130313230928.GA11068@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tyhicks@canonical.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, fanchaoting <fanchaoting@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:48899 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3CNAnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2013 20:43:32 -0400
Received: by mail-da0-f43.google.com with SMTP id u36so657709dak.16
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 17:43:32 -0700 (PDT)
In-Reply-To: <20130313230928.GA11068@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=D4=DA 2013-3-14=A3=AC=C9=CF=CE=E77:09=A3=ACJan Kara <jack@suse.cz> =D0=
=B4=B5=C0=A3=BA

> On Tue 12-03-13 13:06:37, fanchaoting wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>=20
>> commit 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b leads into
>> a regression that casue BUG_ON when unlinking inode.
>>=20
>> Reported-by: tyhicks@canonical.com
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>  I ended up fixing the problem by the attached patch. It looks cleane=
r to
> me that way... Thanks for your fix anyway.

Sorry for delay reply, I am busy with my graduation project these two d=
ays.
However, your patch looks more reasonable than mine.=20

Thanks very much to fanchaoting sending my patch out anyway.

Thanks,
Wang

>=20
> 							Honza
>> ---
>> fs/ext2/balloc.c |    1 -
>> 1 files changed, 0 insertions(+), 1 deletions(-)
>>=20
>> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
>> index 9f9992b..06d82fc 100644
>> --- a/fs/ext2/balloc.c
>> +++ b/fs/ext2/balloc.c
>> @@ -562,7 +562,6 @@ error_return:
>> 	if (freed) {
>> 		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
>> 		dquot_free_block_nodirty(inode, freed);
>> -		mark_inode_dirty(inode);
>> 	}
>> }
>>=20
>> -- 1.7.7.6=20
>>=20
>>=20
>>=20
>>=20
> --=20
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> <0001-ext2-Fix-BUG_ON-in-evict-on-inode-deletion.patch>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
