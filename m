From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/4 v3] tune2fs: update journal super block when changing UUID for fs.
Date: Fri, 1 Aug 2014 08:40:17 +0200
Message-ID: <A1D98B70-C47A-4F59-826B-AD06E491FA81@dilger.ca>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com> <1406533405-6899-4-git-send-email-a3at.mail@gmail.com> <53DA5DDC.1020703@redhat.com> <20140731154527.GM15655@azat>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60516 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaHAGkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 02:40:22 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so3880978wgh.9
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 23:40:20 -0700 (PDT)
In-Reply-To: <20140731154527.GM15655@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I already fixed that in my recent patch:

http://marc.info/?l=3Dlinux-ext4&m=3D140667665421773&w=3D2

Cheers, Andreas

> On Jul 31, 2014, at 17:45, Azat Khuzhin <a3at.mail@gmail.com> wrote:
>=20
>> On Thu, Jul 31, 2014 at 10:16:44AM -0500, Eric Sandeen wrote:
>>> On 7/28/14, 2:43 AM, Azat Khuzhin wrote:
>>> Using -U option you can change the UUID for fs, however it will not=
 work
>>> for journal device, since it have a copy of this UUID inside jsb (i=
=2Ee.
>>> journal super block). So copy UUID on change into that block.
>>>=20
>>> Here is the initial thread:
>>> http://comments.gmane.org/gmane.comp.file-systems.ext4/44532
>>>=20
>>> You can reproduce this by executing following commands:
>>> $ fallocate -l100M /tmp/dev
>>> $ fallocate -l100M /tmp/journal
>>> $ sudo /sbin/losetup /dev/loop1 /tmp/dev
>>> $ sudo /sbin/losetup /dev/loop0 /tmp/journal
>>> $ mke2fs -O journal_dev /tmp/journal
>>> $ tune2fs -U da1f2ed0-60f6-aaaa-92fd-738701418523 /tmp/journal
>>> $ sudo mke2fs -t ext4 -J device=3D/dev/loop0 /dev/loop1
>>> $ dumpe2fs -h /tmp/dev | fgrep UUID
>>> dumpe2fs 1.43-WIP (18-May-2014)
>>> Filesystem UUID:          8a776be9-12eb-411f-8e88-b873575ecfb6
>>> Journal UUID:             e3d02151-e776-4865-af25-aecb7291e8e5
>>> $ sudo e2fsck /dev/vdc
>>> e2fsck 1.43-WIP (18-May-2014)
>>> External journal does not support this filesystem
>>>=20
>>> /dev/loop1: ********** WARNING: Filesystem still has errors *******=
***
>>>=20
>>> Reported-by: Chin Tzung Cheng <chintzung@gmail.com>
>>> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
>>> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
>>> ---
>>> misc/tune2fs.c | 74 ++++++++++++++++++++++++++++++++++++++++++++---=
-----------
>>> 1 file changed, 56 insertions(+), 18 deletions(-)
>>>=20
>>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>>> index 1df655a..74e57ae 100644
>>> --- a/misc/tune2fs.c
>>> +++ b/misc/tune2fs.c
>>> @@ -175,6 +175,38 @@ static __u32 clear_ok_features[3] =3D {
>>>        EXT4_FEATURE_RO_COMPAT_GDT_CSUM
>>> };
>>>=20
>>> +/**
>>> + * Try to get journal super block if any
>>> + */
>>> +static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZ=
E])
>>> +{
>>> +    int retval;
>>> +    int start;
>>> +    journal_superblock_t *jsb;
>>> +
>>> +    if (!(jfs->super->s_feature_incompat &
>>> +        EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
>>> +        return EXT2_ET_UNSUPP_FEATURE;
>>> +    }
>>> +
>>> +    /* Get the journal superblock */
>>> +    if ((retval =3D io_channel_read_blk64(jfs->io,
>>> +        ext2fs_journal_sb_start(jfs->blocksize), -SUPERBLOCK_SIZE,=
 buf))) {
>>> +        com_err(program_name, retval, "%s",
>>> +        _("while reading journal superblock"));
>>> +        return retval;
>>> +    }
>>> +
>>> +    jsb =3D (journal_superblock_t *) buf;
>>> +    if ((jsb->s_header.h_magic !=3D (unsigned)ntohl(JFS_MAGIC_NUMB=
ER)) ||
>>> +        (jsb->s_header.h_blocktype !=3D (unsigned)ntohl(JFS_SUPERB=
LOCK_V2))) {
>>> +        fputs(_("Journal superblock not found!\n"), stderr);
>>> +        return EXT2_ET_BAD_MAGIC;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> /*
>>>  * Remove an external journal from the filesystem
>>>  */
>>> @@ -218,29 +250,15 @@ static int remove_journal_device(ext2_filsys =
fs)
>>>            _("while trying to open external journal"));
>>>        goto no_valid_journal;
>>>    }
>>> -    if (!(jfs->super->s_feature_incompat &
>>> -          EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
>>> -        fprintf(stderr, _("%s is not a journal device.\n"),
>>> -            journal_path);
>>> -        goto no_valid_journal;
>>> -    }
>>>=20
>>> -    start =3D ext2fs_journal_sb_start(fs->blocksize);
>>=20
>> This is already committed (which is why Coverity whined about it), b=
ut:
>> removing this assignment causes an uninitialized use of "start" late=
r
>> in this function:
>>=20
>>        /* Write back the journal superblock */
>>        if ((retval =3D io_channel_write_blk64(jfs->io, start,
>>            -SUPERBLOCK_SIZE, buf)))
>>=20
>> -Eric
>=20
> Hi Eric,
>=20
> Thanks for catching this.
> Patch in attachment must fix this issue.
>=20
> I maked with -Wall to catch more bugs like this.
> And there is one more note:
> expected =E2=80=98char *=E2=80=99 but argument is of type =E2=80=98__=
u8 *=E2=80=99
> journal_user()
> I will send a patch later.
>=20
>=20
> From 903f251e1ebce3d666a8b2af04b812d4f6751056 Mon Sep 17 00:00:00 200=
1
> From: Azat Khuzhin <a3at.mail@gmail.com>
> Date: Thu, 31 Jul 2014 19:26:16 +0400
> Subject: [PATCH] tune2fs: initialize start block in remove_journal_de=
vice()
>=20
> ---
> misc/tune2fs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 0c1feb1..044daaf 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -181,7 +181,6 @@ static __u32 clear_ok_features[3] =3D {
> static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
> {
>    int retval;
> -    int start;
>    journal_superblock_t *jsb;
>=20
>    if (!(jfs->super->s_feature_incompat &
> @@ -286,6 +285,7 @@ static int remove_journal_device(ext2_filsys fs)
>    jsb->s_nr_users =3D htonl(nr_users);
>=20
>    /* Write back the journal superblock */
> +    start =3D ext2fs_journal_sb_start(jfs->blocksize);
>    if ((retval =3D io_channel_write_blk64(jfs->io, start,
>        -SUPERBLOCK_SIZE, buf))) {
>        com_err(program_name, retval,
> --=20
> 2.0.1
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
