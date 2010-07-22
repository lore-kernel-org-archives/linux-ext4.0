From: shenghui <crosslonelyover@gmail.com>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read in
	ext2_xattr_get
Date: Thu, 22 Jul 2010 08:03:18 +0800
Message-ID: <AANLkTikXSOHrIw0SVJMYqsQy1aG5sCXkvvOFU4XLDNGv@mail.gmail.com>
References: <201007122229025316610@gmail.com>
	<20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55122 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab0GVADU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jul 2010 20:03:20 -0400
In-Reply-To: <20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/7/22 Jan Kara <jack@suse.cz>:
>> Hi,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0I walked through ext2_xattr_get, and felt=
 that we can
>> do some optimization on it. For name_len check, it's done
>> after down xattr_sem and sb_read, both of which are time
>> consuming operation compared with strlen:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0down_read(&EXT2_I(inode)->xattr_se=
m);
>> =C2=A0...
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bh =3D sb_bread(inode->i_sb, EXT2_=
I(inode)->i_file_acl);
>> =C2=A0...
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* find named attribute */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name_len =3D strlen(name);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D -ERANGE;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (name_len > 255)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto c=
leanup;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Most of the case, you'll get one valid bl=
ock, but if the
>> name len > 255, then the xattr_sem down and sb_bread operation
>> can be seen as a waste of time. So I think we'd better do
>> name len check as early as possible.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Following is my patch, and it's against 2=
=2E6.35-rc4.
>> Please check it.
>>
>> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
>> ---
>> =C2=A0fs/ext2/xattr.c | =C2=A0 12 +++++++-----
>> =C2=A01 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
>> index 7c39157..0b94d61 100644
>> --- a/fs/ext2/xattr.c
>> +++ b/fs/ext2/xattr.c
>> @@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_in=
dex, const char *name,
>>
>> =C2=A0 =C2=A0 =C2=A0 if (name =3D=3D NULL)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
>> +
>> + =C2=A0 =C2=A0 /* find named attribute */
>> + =C2=A0 =C2=A0 name_len =3D strlen(name);
>> + =C2=A0 =C2=A0 error =3D -ERANGE;
>> + =C2=A0 =C2=A0 if (name_len > 255)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto cleanup;
> =C2=A0But you cannot go to cleanup here because you don't hold xattr_=
sem...
>

Sorry, I'm a little confused by your words.
The patch just checks name_len, and it
doesn't need xattr_sem.



--=20


Thanks and Best Regards,
shenghui
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
