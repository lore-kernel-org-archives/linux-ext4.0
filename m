From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] e2fsprogs: add 64bit-online-resize support
Date: Fri, 12 Aug 2011 16:43:24 +0800
Message-ID: <CAGBYx2YvZWy-ZXtXjMaZGV=ohON8RskjSdvskHTVGHvPqa-C2w@mail.gmail.com>
References: <1313046601-2795-1-git-send-email-xiaoqiangnk@gmail.com>
	<06EFAA62-3D2C-4FEF-A2E3-6363726CBDA8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39931 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1HLInZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Aug 2011 04:43:25 -0400
Received: by gxk21 with SMTP id 21so1821484gxk.19
        for <linux-ext4@vger.kernel.org>; Fri, 12 Aug 2011 01:43:25 -0700 (PDT)
In-Reply-To: <06EFAA62-3D2C-4FEF-A2E3-6363726CBDA8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 3:42 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-08-11, at 1:10 AM, Yongqiang Yang wrote:
>> This patch adds 64bit-resize support to e2fsprogs.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> lib/ext2fs/ext2_fs.h | =A0 =A01 +
>> resize/online.c =A0 =A0 =A0| =A0 22 +++++++++++++++++++++-
>> 2 files changed, 22 insertions(+), 1 deletions(-)
>>
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 54cb3d4..4fec5db 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -327,6 +327,7 @@ struct ext4_new_group_input {
>> #define EXT2_IOC_GROUP_EXTEND =A0 =A0 =A0 =A0 _IOW('f', 7, unsigned =
long)
>> #define EXT2_IOC_GROUP_ADD =A0 =A0 =A0 =A0 =A0 =A0_IOW('f', 8,struct=
 ext2_new_group_input)
>> #define EXT4_IOC_GROUP_ADD =A0 =A0 =A0 =A0 =A0 =A0_IOW('f', 8,struct=
 ext4_new_group_input)
>> +#define EXT4_IOC_RESIZE_FS =A0 =A0 =A0 =A0 =A0 _IOW('f', 16, __u64)
>>
>> /*
>> =A0* Structure of an inode on the disk
>> diff --git a/resize/online.c b/resize/online.c
>> index 1d8d4ec..53ad852 100644
>> --- a/resize/online.c
>> +++ b/resize/online.c
>> @@ -51,7 +51,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const c=
har *mtpt,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->=
super->s_first_data_block,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2=
_BLOCKS_PER_GROUP(fs->super)),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_DESC_PER_BLOCK(fs->super));
>> - =A0 =A0 printf("old desc_blocks =3D %lu, new_desc_blocks =3D %lu\n=
",
>> + =A0 =A0 printf("old_desc_blocks =3D %lu, new_desc_blocks =3D %lu\n=
",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0fs->desc_blocks, new_desc_blocks);
>> =A0 =A0 =A0 if (!(fs->super->s_feature_compat &
>> =A0 =A0 =A0 =A0 =A0 =A0 EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
>> @@ -69,6 +69,26 @@ errcode_t online_resize_fs(ext2_filsys fs, const =
char *mtpt,
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 size=3Dext2fs_blocks_count(sb);
>> +
>> + =A0 =A0 if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (errno =3D=3D ENOTTY) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("Kernel does not su=
pport 64bit-online resizing, "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"tring the =
old style online resizing\n");
>
> s/tring/trying/
>
> In any case, I don't think users care about which ioctl is in use, ju=
st
> that it works correctly on the kernel they are using. =A0IMHO it shou=
ld just
> silently try both ioctls() without any extra warnings.
Thanks, it will be fixed.

Yongqiang.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (errno =3D=3D EPERM)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err(pr=
ogram_name, 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _("Permiss=
ion denied to resize filesystem"));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err(pr=
ogram_name, errno,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _("While c=
hecking for on-line resizing "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "suppo=
rt"));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit(1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 close(fd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 if (ioctl(fd, EXT2_IOC_GROUP_EXTEND, &size)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (errno =3D=3D EPERM)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err(program_name, 0,
>> --
>> 1.7.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
