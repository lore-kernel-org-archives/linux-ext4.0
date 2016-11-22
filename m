From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: JBD2: Spotted dirty metadata buffer....
Date: Tue, 22 Nov 2016 16:02:53 -0700
Message-ID: <A81188A3-AD1E-4472-8504-4FAA26C8C463@dilger.ca>
References: <1744886.OgPgGFoXj7@stwm.de> <FB4C6A4A-2A9F-4AE2-9CA2-E2C1F881A651@dilger.ca> <4346106.R74lp01Hl2@stwm.de>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_89F3902B-C8D6-4DA7-8667-8F19481D15C5"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Wolfgang Walter <linux@stwm.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36037 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932461AbcKVXDD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Nov 2016 18:03:03 -0500
Received: by mail-io0-f172.google.com with SMTP id x94so87326232ioi.3
        for <linux-ext4@vger.kernel.org>; Tue, 22 Nov 2016 15:02:58 -0800 (PST)
In-Reply-To: <4346106.R74lp01Hl2@stwm.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_89F3902B-C8D6-4DA7-8667-8F19481D15C5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Nov 22, 2016, at 6:56 AM, Wolfgang Walter <linux@stwm.de> wrote:
>=20
> Am Montag, 21. November 2016, 17:49:36 schrieben Sie:
>> On Nov 21, 2016, at 8:28 AM, Wolfgang Walter <linux@stwm.de> wrote:
>>> Hello,
>>>=20
>>> I'm testing EXT4 with an external journal (data=3Djournal). When =
writing I
>>> rather often get>
>>> 	JBD2: Spotted dirty metadata buffer (dev =3D dm-22, blocknr =3D =
1008028301).
>>> 	There's a risk of filesystem corruption in case of system crash.
>> Can you please determine what file this block belongs to and/or what =
kind
>> of metadata block it is.  You can check "dumpe2fs /dev/dm-22" to list =
all
>> of the metadata blocks, and if it isn't listed as filesystem =
metadata, you
>> can run "debugfs -c -R 'icheck 1008028301' /dev/dm-22" to find which =
file
>> this block belongs to, then "debugfs -c -R 'ncheck <inum>' =
/dev/dm-22" after
>> you have the inode number.
>=20
> This think this is the metadata block which covers 1008028301? :
>=20
> Group 30762: (Blocks 1008009216-1008041983) csum 0xb3c0 [INODE_UNINIT, =
ITABLE_ZEROED]
>  Block bitmap at 1007681546 (bg #30752 + 10), csum 0x94b3d052
>  Inode bitmap at 1007681562 (bg #30752 + 26), csum 0x00000000
>  Inode table at 1007684128-1007684383 (bg #30752 + 2592)
>  8340 free blocks, 4096 free inodes, 0 directories, 4096 unused inodes
>  Free blocks: 1008021210-1008021211, 1008021506-1008021511, =
1008021520-1008021698, 1008021749-1008021887, 1008022528
> -1008022655, 1008024576-1008024768, 1008024839-1008024959, =
1008026624-1008026879, 1008028524-1008035839
>  Free inodes: 126001153-126005248
>=20
> I'm not sure if I read it correct but 1008028301 is part of the =
metadata?
>=20
> I checked all of the other blocks logged so far and they are all =
alike,
> they are in between <x> and <y> of a "(Blocks <x>-<y>)" and they are =
above
> <b> of the "Inode table at <a>-<b>".

This means that block 1008028301 is part of this block group 30762, but
it is not listed in the range of "Block bitmap", "Inode bitmap", or =
"Inode
table" so it is just a regular block that was allocated to a file.  You
can use "debugfs -c -R 'icheck 1008028301' /dev/dm-22" to find out the
inode this block belongs to, and "debugfs -c -R 'stat <inum>' =
/dev/dm-22"
to see what the block is used for (e.g. data block, indirect block, =
etc).

Unfortunately, I don't think "debugfs icheck" reports the type of block
that this is, even though it probably could.

Cheers, Andreas

> Another thing I found was that no block has been mentioned more then =
twice.
> If they are mentioned twice this is within a second or so. Maybe this =
is
> simply because they only where touched when I did the rsync.
>=20
> Here is an example:
>=20
> [303709.144704] JBD2: Spotted dirty metadata buffer (dev =3D dm-22, =
blocknr =3D 1085342550). There's a risk of filesystem corruption in case =
of system crash.
> [303709.145561] JBD2: Spotted dirty metadata buffer (dev =3D dm-22, =
blocknr =3D 1085342538). There's a risk of filesystem corruption in case =
of system crash.
>=20
>>=20
>>> No other message is logged. If I unmount the filesystem an do an =
forced
>>> fsck, all seems fine.
>> This is likely a bug in the code, marking a block dirty without =
setting
>> up the journaling for it correctly.  A few bugs like this were fixed =
a
>> while ago by Eric, but those fixes should be in 4.8.8.
>>=20
>>> The filesystem as it's journal are on a LV (which is again backed by
>>> DRBD). The journal, too.
>>>=20
>>> I'm using stable kernel 4.8.8.
>>>=20
>>> I created the journal with:
>>> 	mkfs.ext4 -O journal_dev -v -b 4096  -L jdyn /dev/export/jdyn
>>>=20
>>> I created the filesystem with:
>>> 	mkfs.ext4 -J device=3DUUID=3D625d871f-c278-4acb-916d-774dc78dbd8a =
-v -b 4096
>>> 	-E
>>> 	=
stride=3D$((512/4)),stripe_width=3D$((512/4*3)),lazy_itable_init=3D0,nodis=
card
>>> 	-O inline_data,mmp -L dyn /dev/export/dyn
>> It may be that inline_data is the culprit, since this is a relatively =
new
>> feature that isn't widely used yet.
>>=20
>> Cheers, Andreas
>>=20
>>> I tested it also with data=3Dwriteback. I didn't see these errors =
then.
>>>=20
>>> Regards,
>>> --
>>> Wolfgang Walter
>>> Studentenwerk M=FCnchen
>>> Anstalt des =F6ffentlichen Rechts
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe =
linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>> Cheers, Andreas
>=20
> Regards,
> --
> Wolfgang Walter
> Studentenwerk M=FCnchen
> Anstalt des =F6ffentlichen Rechts


Cheers, Andreas






--Apple-Mail=_89F3902B-C8D6-4DA7-8667-8F19481D15C5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDTOnnKl2rkXzB/gAQgKuxAAmX3ABLXNg4dMMilHf+QZ7PcWl/hXZ9GX
Ke5g2SbB0WrDtcgW0xWE6vDB+iOgOGBW1P5+Go+ZuRHl/+l7U2w5G4NXRc2C7YF5
tPZ2e8EITJwo4cHQtyRibmYaBgSu4E//6j5xuPhm+zqS1cbq2oGL1MqpoUoTBdWC
9m5S75+Sq15iNxY6+BvGjA08WtP5cbgwj3GscLLTBpNhoFpsD+rnZ514tzkBiGG7
c3kBflr6qze0MJGhuhTyASRqnouhSWYz4fVavsBMBB6HQeLcKACnxIsFM9M3XFKf
oO2s5vIrVhnMyKRCXNMUqt1X6zcMifLI+gm3hP4kTO/gmXSFJ0Ip/ZnIr8kkkq+h
ARHxjwtkdOQOgP8uHwBBC7jw75IjOGBoIrCwqmlmc4v280mvROnidS6zn4MpNfQO
qUcm/c25uM3I537dr6w5ZdAriFixdnfWRb53fLAfFYkAIN5jXpZO0mL9eQFrsw+p
IFmk7nRWzvXp+p6y49QC7YyaIh1JmTth1FCsQrN6XXOUEb9yAiJ3zU5OFzkQCbjE
fK58Loids0nkW2mIhrnK727aVMeHrQSFvoZ4pY2ZPyJaV3Rhyu1kqIf4Y1Tyo5FY
Q3a6DCp1Ad3P4E5c9gJv4fHW9FMmvAp7ksNt+1rJJNhTwrpSEcGtn+hcXngyC76b
gzwFC1f1gS4=
=IUSa
-----END PGP SIGNATURE-----

--Apple-Mail=_89F3902B-C8D6-4DA7-8667-8F19481D15C5--
