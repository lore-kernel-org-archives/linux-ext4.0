From: Boxi Liu <boxi10liu@gmail.com>
Subject: Re: fix the ext4_read_inline_dir return value
Date: Wed, 18 Sep 2013 01:30:36 +0800
Message-ID: <CAAFszuWdFeyc7EZBbfnegmE_64eyE-PE3MRBYfTdnv0gYSgm4g@mail.gmail.com>
References: <CAAFszuWi7u_-eYFBB=hvWqfZBcZBhneVK8m6JZhzd9Hakh8oiA@mail.gmail.com>
	<20130917162916.GA16938@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Robin Dong <sanbai@taobao.com>,
	"tm@tao.ma" <tm@tao.ma>, "lewis.liulei" <lewis.liulei@huawei.com>,
	pamirs <pamirs@163.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:65532 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3IQRag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Sep 2013 13:30:36 -0400
Received: by mail-ie0-f179.google.com with SMTP id e14so11043309iej.10
        for <linux-ext4@vger.kernel.org>; Tue, 17 Sep 2013 10:30:36 -0700 (PDT)
In-Reply-To: <20130917162916.GA16938@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks to point the that,I will fix it.

ext4: fix the ext4_read_inline_dir return value

In ext4_read_inlne_dir,the return value is the return
of ext4_read_inline_data len.But in no inline_data case,
the return value is 0,it's inconsistent.So fix the return
value of ext4_read_inline_dir.

Signed-off-by: BoxiLiu <lewis.liulei@huawei.com>
---
 fs/ext4/inline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d9ecbf1..c3efb65 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1442,6 +1442,7 @@ int ext4_read_inline_dir(struct file *file,
  if (ret < 0)
  goto out;

+ ret =3D 0;
  sb =3D inode->i_sb;
  parent_ino =3D le32_to_cpu(((struct ext4_dir_entry_2 *)dir_buf)->inod=
e);
  offset =3D ctx->pos;
--=20

2013/9/18 Jan Kara <jack@suse.cz>:
> On Tue 17-09-13 23:08:51, Boxi Liu wrote:
>> hi=A3=AC
>> there may be a bug in ext4_read_inline_dir() function with inline_da=
ta feature.
>> when I recursion call a sys_old_readdir to read a direntry's
>> sub_dentry,I find that the ext4_read_inline_dir return the len of th=
e
>> inline_data ,but in the no inline_data case,it will return 0.It is
>> inconsistent.
>> So I try to make a patch to fix it.
>   The patch is fine, thanks for finding the bug. But please read
> Documentation/SubmittingPatches about how your patch should be format=
ted.
> In particular your patch has damaged whitespace (tabs converted to sp=
aces).
> Gmail does this - you have to send the patch as an attachment to avoi=
d this
> when using gmail.  Also your patch misses Signed-off-by line.
>
>                                                                 Honza
>>
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index d9ecbf1..3ea39cd 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
>> @@ -1441,7 +1441,7 @@ int ext4_read_inline_dir(struct file *file,
>>   up_read(&EXT4_I(inode)->xattr_sem);
>>   if (ret < 0)
>>   goto out;
>> -
>> +   ret =3D 0;
>>   sb =3D inode->i_sb;
>>   parent_ino =3D le32_to_cpu(((struct ext4_dir_entry_2 *)dir_buf)->i=
node);
>>   offset =3D ctx->pos;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
