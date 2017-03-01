From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] libext2fs: readahead for meta_bg
Date: Tue, 28 Feb 2017 21:35:07 -0700
Message-ID: <34190257-2334-4DA5-90BD-AA0F7167E4C2@dilger.ca>
References: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
 <42AA3FB8-88C4-4616-A20F-D09F0833D288@dilger.ca>
 <62970C8A-AEB5-4AE8-8C83-C9BA41D313AB@gmail.com>
 <4F4ECDB0-7939-4F3D-8995-0BA6A96C658E@dilger.ca>
 <0EDACE55-899D-4A27-936D-8CD31E9C577A@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_13404CA5-B62F-4E40-A580-00B800A7F113";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36354 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdCAFHA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Mar 2017 00:07:00 -0500
Received: by mail-io0-f194.google.com with SMTP id 68so196821ioh.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 21:07:00 -0800 (PST)
In-Reply-To: <0EDACE55-899D-4A27-936D-8CD31E9C577A@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_13404CA5-B62F-4E40-A580-00B800A7F113
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Feb 28, 2017, at 9:02 PM, Alexey Lyashkov <alexey.lyashkov@gmail.com> =
wrote:
>=20
>=20
>> 1 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2017 =D0=B3., =D0=B2 5:50, Andreas =
Dilger <adilger@dilger.ca> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0=
):
>>=20
>> On Feb 28, 2017, at 7:19 PM, Alexey Lyashkov =
<alexey.lyashkov@gmail.com> wrote:
>>>=20
>>> Andreas,
>>>=20
>>> we have do it first. But patch was much and much complex due =
checksums handling in code.
>>> and ext2_flush() will be need to read an all GD in memory to as use =
a flat array to write a GD to the disk.
>>=20
>> Yes, I saw ext2_flush() was accessing the array directly, and would =
have a
>> problem as you describe.  One option would be to skip writing =
uninitialized
>> GDT blocks, but that also becomes more complex to get correct.
> checking agains a inode bitmap block number is enough, to see is GD =
read from disk or not.

It would be possible to check only the inode bitmap location (low and =
high word)
is zero, but memcmp(gdt, zero_gdt, sizeof(*gdt)) just as easy, and =
safer.

>>> If you want we have submit it also, but it have no benefits (like a =
few seconds), against it simple version.
>>=20
>> I guess a large part of your speedup is because of submitting the GDT =
reads
>> in parallel to a disk array.  If the GDT blocks are all mapped to a =
single
>> disk in the array (entirely possible with META_BG, depending on array
>> geometry) then the prefetch will have minimal benefits.
>=20
> yes and no. it will have a benefits because avoid a delay between =
sending a new requests so io scheduler may optimize it better.
> from other view - we have additional delay between submit and access =
due processing a previously request, while IO subsystem may work in this =
time.
> Both these cases will provide a good benefit.
> But again - I may ask an Artem submit a patch to read GD by demand as =
it ready again, but it don=E2=80=99t like it due a complexity.

Sure, it would be good to send it to the list, just to see where =
complexity
is and discuss how it might be fixed.

My 5-minute investigation showed loading the GDT block in =
ext2fs_group_desc()
would cover almost all of the use cases, and some of them (e.g. =
filesystem
clone/copy) could also just do on-demand loading for the GDT copy.

The tricky part is to handle GDT writeout correctly, otherwise the GDT =
may
be overwritten by zero-filled buffers.  The number of cases of direct =
buffer
access is very small.  In fact, most of the users of ext2fs_group_desc()
could lose the fs->group_desc argument and just get this internally, so
that it is clear when it is being used on an external buffer (only in =
one
or two places).

>> Another option would be to change debugfs/tune2fs/dumpe2fs to use the
>> EXT2_FLAG_SUPER_ONLY flag to only read the superblock on open if the
>> requested operations do not need access to the group descriptors at =
all?
>> For a large filesystem as you describe, 37K GDT blocks is still over =
144MB
>> of data that needs to be read from disk, vs 4KB for the superblock.
>=20
> It not an option. If we talk about lustre - debugfs uses to mount data =
copy from raid to local disk to parse.  It mean we need a GD covers =
directory inode
> in memory and full inode read to have an checks passed.

Sure, but for some of the operations (e.g. "debugfs -c -R features", or
"dumpe2fs -h" or "tune2fs [-cCeEgimrTuLM]" and similar) can work with =
only
the superblock, and possibly just the first GDT block to load the =
journal
inode or bad blocks inode.

> I tries it also, but it need to disable a checks inside of libe2fs.

Sure, it depends on how much needs to be disabled in order to work.  If =
there
is on-demand loading, then those changes are also minimized.  There may =
need
to be an EXT2_FLAG_LAZY_GDT open flag also, to indicate that the caller =
knows
that the fs->group_desc table may not be fully loaded, and that a full =
scan is
needed before writing it out.

Cheers, Andreas

>>>> 1 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2017 =D0=B3., =D0=B2 3:10, Andreas =
Dilger <adilger@dilger.ca> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0=
):
>>>>=20
>>>> On Feb 20, 2017, at 3:03 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>>>>>=20
>>>>> From: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>>>>>=20
>>>>> There are ~37k of random IOs with meta_bg option on 300T target.
>>>>> Debugfs requires 20 minutes to be started. Enabling readahead for
>>>>> group blocks metadata save time dramatically. Only 12s to start.
>>>>>=20
>>>>> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>>>>=20
>>>> This patch looks good by itself.
>>>>=20
>>>> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
>>>> ----
>>>>=20
>>>> On a related note, I've been wondering if it would make sense to =
have
>>>> a second patch that *only* does the readahead of the group =
descriptor blocks
>>>> in ext2fs_open2(), and move io_channel_read_blk64() to =
ext2fs_group_desc()
>>>> when the group descriptor blocks are actually accessed the first =
time?  This
>>>> would allow tools like tune2fs, debugfs, dumpe2fs, etc. that may =
not access
>>>> group descriptors to load _much_ faster than if it loads all of the =
bitmaps
>>>> synchronously at filesystem open time.  Even if they _do_ access =
the GDT it
>>>> will at least allow the prefetch more time to run in the =
background, and the
>>>> GDT swabbing happen incrementally upon access rather than all at =
the start.
>>>>=20
>>>> A quick look through lib/ext2fs looks like ext2fs_group_desc() is =
used for
>>>> the majority of group descriptor accesses, but there are a few =
places that
>>>> access fs->group_desc directly.  The ext2fs_group_desc() code could =
check
>>>> whether the group descriptor is all-zero (ext2fs_open2() should be =
changed
>>>> to use ext2fs_get_array_zero(..., &fs->group_desc)) and if so read =
the whole
>>>> descriptor block into the array and optionally swab it.
>>>>=20
>>>> Cheers, Andreas
>>>>=20
>>>>> ---
>>>>> lib/ext2fs/openfs.c |    6 ++++++
>>>>> 1 files changed, 6 insertions(+), 0 deletions(-)
>>>>>=20
>>>>> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
>>>>> index ba501e6..f158b0a 100644
>>>>> --- a/lib/ext2fs/openfs.c
>>>>> +++ b/lib/ext2fs/openfs.c
>>>>> @@ -399,6 +399,12 @@ errcode_t ext2fs_open2(const char *name, =
const char *io_options,
>>>>> #endif
>>>>> 		dest +=3D fs->blocksize*first_meta_bg;
>>>>> 	}
>>>>> +
>>>>> +	for (i =3D first_meta_bg ; i < fs->desc_blocks; i++) {
>>>>> +		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
>>>>> +		io_channel_cache_readahead(fs->io, blk, 1);
>>>>> +	}
>>>>> +
>>>>> 	for (i=3Dfirst_meta_bg ; i < fs->desc_blocks; i++) {
>>>>> 		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
>>>>> 		retval =3D io_channel_read_blk64(fs->io, blk, 1, dest);
>>>>> --
>>>>> 1.7.1
>>>>>=20
>>>>=20
>>>>=20
>>>> Cheers, Andreas
>>>>=20
>>>>=20
>>>>=20
>>>>=20
>>>>=20
>>>=20
>>=20
>>=20
>> Cheers, Andreas
>>=20
>>=20
>>=20
>>=20
>>=20
>=20


Cheers, Andreas






--Apple-Mail=_13404CA5-B62F-4E40-A580-00B800A7F113
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYtk98pIg59Q01vtYRAjSgAJ9rj18CcFtSs75bzll5JNbJE5deHACeLeA2
a84haGWSSAr3shY3bffNzFY=
=yjrC
-----END PGP SIGNATURE-----

--Apple-Mail=_13404CA5-B62F-4E40-A580-00B800A7F113--
