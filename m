From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH] libext2fs: readahead for meta_bg
Date: Wed, 1 Mar 2017 05:19:57 +0300
Message-ID: <62970C8A-AEB5-4AE8-8C83-C9BA41D313AB@gmail.com>
References: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
 <42AA3FB8-88C4-4616-A20F-D09F0833D288@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32956 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdCACUH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Feb 2017 21:20:07 -0500
Received: by mail-pf0-f194.google.com with SMTP id p185so2189984pfb.0
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 18:20:06 -0800 (PST)
In-Reply-To: <42AA3FB8-88C4-4616-A20F-D09F0833D288@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas,

we have do it first. But patch was much and much complex due checksums =
handling in code.
and ext2_flush() will be need to read an all GD in memory to as use a =
flat array to write a GD to the disk.
If you want we have submit it also, but it have no benefits (like a few =
seconds), against it simple version.


> 1 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2017 =D0=B3., =D0=B2 3:10, Andreas =
Dilger <adilger@dilger.ca> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0=
):
>=20
> On Feb 20, 2017, at 3:03 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>>=20
>> From: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>>=20
>> There are ~37k of random IOs with meta_bg option on 300T target.
>> Debugfs requires 20 minutes to be started. Enabling readahead for
>> group blocks metadata save time dramatically. Only 12s to start.
>>=20
>> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>=20
> This patch looks good by itself.
>=20
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> ----
>=20
> On a related note, I've been wondering if it would make sense to have
> a second patch that *only* does the readahead of the group descriptor =
blocks
> in ext2fs_open2(), and move io_channel_read_blk64() to =
ext2fs_group_desc()
> when the group descriptor blocks are actually accessed the first time? =
 This
> would allow tools like tune2fs, debugfs, dumpe2fs, etc. that may not =
access
> group descriptors to load _much_ faster than if it loads all of the =
bitmaps
> synchronously at filesystem open time.  Even if they _do_ access the =
GDT it
> will at least allow the prefetch more time to run in the background, =
and the
> GDT swabbing happen incrementally upon access rather than all at the =
start.
>=20
> A quick look through lib/ext2fs looks like ext2fs_group_desc() is used =
for
> the majority of group descriptor accesses, but there are a few places =
that
> access fs->group_desc directly.  The ext2fs_group_desc() code could =
check
> whether the group descriptor is all-zero (ext2fs_open2() should be =
changed
> to use ext2fs_get_array_zero(..., &fs->group_desc)) and if so read the =
whole
> descriptor block into the array and optionally swab it.
>=20
> Cheers, Andreas
>=20
>> ---
>> lib/ext2fs/openfs.c |    6 ++++++
>> 1 files changed, 6 insertions(+), 0 deletions(-)
>>=20
>> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
>> index ba501e6..f158b0a 100644
>> --- a/lib/ext2fs/openfs.c
>> +++ b/lib/ext2fs/openfs.c
>> @@ -399,6 +399,12 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
>> #endif
>> 		dest +=3D fs->blocksize*first_meta_bg;
>> 	}
>> +
>> +	for (i =3D first_meta_bg ; i < fs->desc_blocks; i++) {
>> +		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
>> +		io_channel_cache_readahead(fs->io, blk, 1);
>> +	}
>> +
>> 	for (i=3Dfirst_meta_bg ; i < fs->desc_blocks; i++) {
>> 		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
>> 		retval =3D io_channel_read_blk64(fs->io, blk, 1, dest);
>> --
>> 1.7.1
>>=20
>=20
>=20
> Cheers, Andreas
>=20
>=20
>=20
>=20
>=20
