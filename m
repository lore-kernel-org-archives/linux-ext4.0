From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext3: Avoid creating new file in append-only dir when
 open(2) return error
Date: Wed, 2 Nov 2011 10:05:35 +0800
Message-ID: <CA+dCu8_cHh7EeSnkO-KH7LM4aOqt0noHtO6ZyU4YS=Ff+BVChg@mail.gmail.com>
References: <1319824987-5621-1-git-send-email-guaneryu@gmail.com> <20111101231034.GI18701@quack.suse.cz>
Reply-To: guaneryu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56039 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab1KBCF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 22:05:57 -0400
Received: by wyh15 with SMTP id 15so1015489wyh.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Nov 2011 19:05:56 -0700 (PDT)
In-Reply-To: <20111101231034.GI18701@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 2, 2011 at 7:10 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 29-10-11 02:03:07, Eryu Guan wrote:
>> Newly created file on ext3 inherits inode flags from parent director=
y,
>> so new inode created in append-only directory has S_APPEND flag set,
>> may_open() called by do_last() checks that flag then returns -EPERM,
>> but at that time the new inode is already created.
>>
>> This can be reproduced by:
>> =A0 =A0 =A0 # mkdir -p /mnt/ext3/append-only
>> =A0 =A0 =A0 # chattr +a /mnt/ext3/append-only
>> =A0 =A0 =A0 # ./opentest /mnt/ext3/append-only/newtestfile
>> =A0 =A0 =A0 # ls -l /mnt/ext3/append-only/newtestfile
>>
>> opentest will return 'Operation not permitted', but the ls shows tha=
t
>> newtestfile is already created.
>>
>> =A0 =A0 =A0 # cat opentest.c
>> =A0 =A0 =A0 #include <stdio.h>
>> =A0 =A0 =A0 #include <sys/types.h>
>> =A0 =A0 =A0 #include <fcntl.h>
>> =A0 =A0 =A0 #include <sys/stat.h>
>>
>> =A0 =A0 =A0 int main(int argc, char *argv[])
>> =A0 =A0 =A0 {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int fd;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fd =3D open(argv[1], O_RDWR|O_CREAT, 066=
6);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fd =3D=3D -1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 perror("open failed");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 }
>>
>> To avoid this, check EXT3_APPEND_FL flag first in ext3_create before
>> really allocating new inode.
> =A0Yes, it is nicer to not create any file when open(2) fails in the =
end.
> BTW, how have you spotted this? I've taken your ext2 and ext3 patches=
 into
> my tree.

I found this by xfstests 079, since it's no longer xfs specific and
fails on extN.
After applying my patch, 079 still fails on extN, but not leave
unwanted file there.

As Ted said, the other way to fix this is to remove EXTx_APPEND_FL from
EXTx_FL_INHERITED, so new inode will not inherit the append-only flag. =
This fix
will also make 079 pass on extN.

Though I prefer the later way, I still sent out my patch for review,
because it's
not a behavior-changer.

Thanks.
Eryu Guan
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>> ---
>> =A0fs/ext3/namei.c | =A0 10 ++++++++++
>> =A01 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
>> index 0629e09..323cf2f 100644
>> --- a/fs/ext3/namei.c
>> +++ b/fs/ext3/namei.c
>> @@ -36,6 +36,7 @@
>> =A0#include <linux/quotaops.h>
>> =A0#include <linux/buffer_head.h>
>> =A0#include <linux/bio.h>
>> +#include <linux/namei.h>
>> =A0#include <trace/events/ext3.h>
>>
>> =A0#include "namei.h"
>> @@ -1704,6 +1705,15 @@ static int ext3_create (struct inode * dir, s=
truct dentry * dentry, int mode,
>> =A0 =A0 =A0 handle_t *handle;
>> =A0 =A0 =A0 struct inode * inode;
>> =A0 =A0 =A0 int err, retries =3D 0;
>> + =A0 =A0 int open_flag =3D nd->intent.open.file->f_flags;
>> +
>> + =A0 =A0 if ((EXT3_I(dir)->i_flags & EXT3_FL_INHERITED) & EXT3_APPE=
ND_FL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((open_flag & O_ACCMODE) !=3D O_RDONLY =
&&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !(open_flag & O_APPEND))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (open_flag & O_TRUNC)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 dquot_initialize(dir);
>>
>> --
>> 1.7.7.1
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
