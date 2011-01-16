From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all
 failed mount paths.
Date: Sun, 16 Jan 2011 10:05:08 -0800
Message-ID: <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com> <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	mkatiyar@gmail.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39663 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1APSF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Jan 2011 13:05:29 -0500
Received: by qwa26 with SMTP id 26so4118659qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 16 Jan 2011 10:05:28 -0800 (PST)
In-Reply-To: <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 16, 2011 at 8:20 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> Why not just put the iput() at failed_mount4() instead of spread arou=
nd the code?

Thanks Andreas, Here is the updated patch.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/super.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb10a06..8fa53e9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3522,17 +3522,16 @@ no_journal:
        if (IS_ERR(root)) {
                ext4_msg(sb, KERN_ERR, "get root inode failed");
                ret =3D PTR_ERR(root);
+               root =3D NULL;
                goto failed_mount4;
        }
        if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size)=
 {
-               iput(root);
                ext4_msg(sb, KERN_ERR, "corrupt root inode, run e2fsck"=
);
                goto failed_mount4;
        }
        sb->s_root =3D d_alloc_root(root);
        if (!sb->s_root) {
                ext4_msg(sb, KERN_ERR, "get root dentry failed");
-               iput(root);
                ret =3D -ENOMEM;
                goto failed_mount4;
        }
@@ -3648,6 +3647,8 @@ cantfind_ext4:
        goto failed_mount;

 failed_mount4:
+       iput(root);
+       sb->s_root =3D NULL;
        ext4_msg(sb, KERN_ERR, "mount failed");
        destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
 failed_mount_wq:
--=20
1.7.1



>
> Cheers, Andreas
>
> On 2011-01-16, at 0:30, Manish Katiyar <mkatiyar@gmail.com> wrote:
>
>> Fix missing iput for root inode in case of all failed mount paths.
>> Fixes bug#26752
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>>
>> ---
>> fs/ext4/super.c | =A0 =A08 +++++++-
>> 1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index cb10a06..9570fcc 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3587,6 +3587,7 @@ no_journal:
>> =A0 =A0 =A0 =A0if (err) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "failed to ini=
tialize system "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "zone (%d)", err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>> =A0 =A0 =A0 =A0}
>>
>> @@ -3595,12 +3596,15 @@ no_journal:
>> =A0 =A0 =A0 =A0if (err) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "failed to ini=
tialize mballoc (%d)",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0err =3D ext4_register_li_request(sb, first_not_zeroed=
);
>> - =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>> + =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0sbi->s_kobj.kset =3D ext4_kset;
>> =A0 =A0 =A0 =A0init_completion(&sbi->s_kobj_unregister);
>> @@ -3609,6 +3613,7 @@ no_journal:
>> =A0 =A0 =A0 =A0if (err) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_mb_release(sb);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_release(sb);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(root);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto failed_mount4;
>> =A0 =A0 =A0 =A0};
>>
>> @@ -3648,6 +3653,7 @@ cantfind_ext4:
>> =A0 =A0 =A0 =A0goto failed_mount;
>>
>> failed_mount4:
>> + =A0 =A0 =A0 sb->s_root =3D NULL;
>> =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR, "mount failed");
>> =A0 =A0 =A0 =A0destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
>> failed_mount_wq:
>> --
>> 1.7.1
>>
>>
>> --
>> Thanks -
>> Manish
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [$\*.^ -- I miss being one of them
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks -
Manish
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[$\*.^ -- I miss being one of them
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
