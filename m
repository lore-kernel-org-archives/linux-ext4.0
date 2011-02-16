From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] e2fsprogs: turn off enforced fsck intervals by default
Date: Wed, 16 Feb 2011 21:12:21 +0200
Message-ID: <AANLkTik1wVdfjd4PH8rf3rKnunGtXfSPiJ_qzu0-HR5J@mail.gmail.com>
References: <4D5C1380.2020602@redhat.com>
	<4D5C1409.1030203@redhat.com>
	<alpine.LFD.2.00.1102161920590.3156@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62197 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1BPTMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Feb 2011 14:12:22 -0500
Received: by qyj19 with SMTP id 19so4000229qyj.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 11:12:22 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1102161920590.3156@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 16, 2011 at 8:24 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Wed, 16 Feb 2011, Eric Sandeen wrote:
>
>> The forced fsck often comes at unexpected and inopportune moments,
>> and even enterprise customers are often caught by surprise when
>> this happens. =A0Because a filesystem with an error condition will
>> be marked as requiring fsck anyway, I submit that the time-based
>> and mount-based checks are not particularly useful, and that
>> administrators can schedule fscks on their own time, or tune2fs
>> the enforced intervals if they so choose. =A0Patch #1 disables the
>> intervals by default, and I've added a new mkfs option (-C) to
>> turn on the old behavior of random, unexpected, time-consuming
>> fscks at boot time. =A0;)
>
> I completely agree with you and I like the idea.

I second that, though I would change the mkfs option to -OCD ;-)

>
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
>> index a204eb7..37584aa 100644
>> --- a/lib/ext2fs/ext2fs.h
>> +++ b/lib/ext2fs/ext2fs.h
>> @@ -184,6 +184,7 @@ typedef struct ext2_file *ext2_file_t;
>> =A0#define EXT2_FLAG_64BITS =A0 =A0 =A0 =A0 =A0 =A0 0x20000
>> =A0#define EXT2_FLAG_PRINT_PROGRESS =A0 =A0 0x40000
>> =A0#define EXT2_FLAG_DIRECT_IO =A0 =A0 =A0 =A0 =A00x80000
>> +#define EXT2_FLAG_MOUNT_FSCK_CHECK =A0 0x100000
>>
>> =A0/*
>> =A0 * Special flag in the ext2 inode i_flag field that means that th=
is is
>> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
>> index 7c38975..ff63a92 100644
>> --- a/lib/ext2fs/initialize.c
>> +++ b/lib/ext2fs/initialize.c
>> @@ -155,7 +155,6 @@ errcode_t ext2fs_initialize(const char *name, in=
t flags,
>> =A0 =A0 =A0 set_field(s_log_block_size, 0); /* default blocksize: 10=
24 bytes */
>> =A0 =A0 =A0 set_field(s_log_frag_size, 0); /* default fragsize: 1024=
 bytes */
>> =A0 =A0 =A0 set_field(s_first_data_block, super->s_log_block_size ? =
0 : 1);
>> - =A0 =A0 set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
>> =A0 =A0 =A0 set_field(s_errors, EXT2_ERRORS_DEFAULT);
>> =A0 =A0 =A0 set_field(s_feature_compat, 0);
>> =A0 =A0 =A0 set_field(s_feature_incompat, 0);
>> @@ -189,7 +188,10 @@ errcode_t ext2fs_initialize(const char *name, i=
nt flags,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_inode_size =3D EXT2_GOOD_OLD_IN=
ODE_SIZE;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 set_field(s_checkinterval, EXT2_DFL_CHECKINTERVAL);
>> + =A0 =A0 if (flags & EXT2_FLAG_MOUNT_FSCK_CHECK) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 set_field(s_max_mnt_count, EXT2_DFL_MAX_MN=
T_COUNT);
>> + =A0 =A0 =A0 =A0 =A0 =A0 set_field(s_checkinterval, EXT2_DFL_CHECKI=
NTERVAL);
>> + =A0 =A0 }
>> =A0 =A0 =A0 super->s_mkfs_time =3D super->s_lastcheck =3D fs->now ? =
fs->now : time(NULL);
>>
>> =A0 =A0 =A0 super->s_creator_os =3D CREATOR_OS;
>> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
>> index 2eead17..758307f 100644
>> --- a/misc/mke2fs.8.in
>> +++ b/misc/mke2fs.8.in
>> @@ -18,6 +18,9 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
>> =A0.I block-size
>> =A0]
>> =A0[
>> +.B \-C
>> +]
>> +[
>> =A0.B \-f
>> =A0.I fragment-size
>> =A0]
>> @@ -184,6 +187,10 @@ Check the device for bad blocks before creating=
 the file system. =A0If
>> =A0this option is specified twice, then a slower read-write
>> =A0test is used instead of a fast read-only test.
>> =A0.TP
>> +.B \-C
>> +Set maximum mount count and interval between checks, so that a full=
 fsck
>> +will be enforced when these counts are exceeded.
>> +.TP
>> =A0.BI \-E " extended-options"
>> =A0Set extended options for the filesystem. =A0Extended options are =
comma
>> =A0separated, and may take an argument using the equals ('=3D') sign=
=2E =A0The
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index 0ba4a4c..fdeafe3 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -80,6 +80,7 @@ const char * device_name /* =3D NULL */;
>>
>> =A0/* Command line options */
>> =A0int =A0cflag;
>> +int =A0Cflag;
>
> Uff, this is not really an issue, however would it be possible to hav=
e
> better name for Cflags :) ? it is just confusing.
>
>> =A0int =A0verbose;
>> =A0int =A0quiet;
>> =A0int =A0super_only;
>> @@ -1228,7 +1229,7 @@ profile_error:
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 while ((c =3D getopt (argc, argv,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "b:cf:g:G:i:jl:m:no:qr:s:t:vE:FI:J=
:KL:M:N:O:R:ST:U:V")) !=3D EOF) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "b:cf:g:G:i:jl:m:no:qr:s:t:vCE:FI:=
J:KL:M:N:O:R:ST:U:V")) !=3D EOF) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (c) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'b':
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocksize =3D strtol(opt=
arg, &tmp, 0);
>> @@ -1251,6 +1252,9 @@ profile_error:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'c': =A0 =A0 =A0 /* Check for bad b=
locks */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cflag++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 case 'C': =A0 =A0 =A0 /* Set default check=
/fsck intervals */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Cflag++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'f':
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D strtoul(optarg,=
 &tmp, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (size < EXT2_MIN_BLOC=
K_SIZE ||
>> @@ -2030,6 +2034,8 @@ int main (int argc, char *argv[])
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if (!quiet)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D EXT2_FLAG_PRINT_PROGRESS;
>> + =A0 =A0 if (Cflag)
>> + =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D EXT2_FLAG_MOUNT_FSCK_CHECK;
>> =A0 =A0 =A0 retval =3D ext2fs_initialize(device_name, flags, &fs_par=
am, io_ptr, &fs);
>> =A0 =A0 =A0 if (retval) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err(device_name, retval, _("while se=
tting up superblock"));
>> @@ -2109,9 +2115,11 @@ int main (int argc, char *argv[])
>> =A0 =A0 =A0 =A0* don't check all the filesystems at the same time. =A0=
We use a
>> =A0 =A0 =A0 =A0* kludgy hack of using the UUID to derive a random ji=
tter value.
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 for (i =3D 0, val =3D 0 ; i < sizeof(fs->super->s_uuid); i=
++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 val +=3D fs->super->s_uuid[i];
>> - =A0 =A0 fs->super->s_max_mnt_count +=3D val % EXT2_DFL_MAX_MNT_COU=
NT;
>> + =A0 =A0 if (Cflag) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0, val =3D 0 ; i < sizeof(fs->s=
uper->s_uuid); i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val +=3D fs->super->s_uuid=
[i];
>> + =A0 =A0 =A0 =A0 =A0 =A0 fs->super->s_max_mnt_count +=3D val % EXT2=
_DFL_MAX_MNT_COUNT;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Override the creator OS, if applicable
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
