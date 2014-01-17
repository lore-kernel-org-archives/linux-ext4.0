From: Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: What is status of metadata_csum
Date: Fri, 17 Jan 2014 21:13:11 +0100
Message-ID: <52D98ED7.8050608@rempel-privat.de>
References: <52D7BB10.5090003@rempel-privat.de> <20140117020009.GL9229@birch.djwong.org> <52D8E755.6030205@rempel-privat.de> <52D9084B.8030501@rempel-privat.de> <20140117192117.GC3897@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xF65QrD0ArGt4w5O8DcVF1wWAgiUdI60K"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59388 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaAQUNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jan 2014 15:13:21 -0500
Received: from [192.168.1.221] ([93.218.75.192]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LeeNW-1VYnvF3ZLq-00qSMT for
 <linux-ext4@vger.kernel.org>; Fri, 17 Jan 2014 21:13:19 +0100
In-Reply-To: <20140117192117.GC3897@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xF65QrD0ArGt4w5O8DcVF1wWAgiUdI60K
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.01.2014 20:21, schrieb Darrick J. Wong:
> On Fri, Jan 17, 2014 at 11:39:07AM +0100, Oleksij Rempel wrote:
>> Am 17.01.2014 09:18, schrieb Oleksij Rempel:
>>> Am 17.01.2014 03:00, schrieb Darrick J. Wong:
>>>> On Thu, Jan 16, 2014 at 11:57:20AM +0100, Oleksij Rempel wrote:
>>>>> What is metadata_csum status?
>>>>>
>>>>> i see there are benchmark updates on wiki page, but no updates for
>>>>> e2fsprogs. 1.43-WIP seems to be really old.
>>>>
>>>> Still waiting for 1.43.  I don't know if there are early adopters ru=
nning
>>>> 1.43-WIP without complaint, or if simply nobody's using it at all. :=
/
>>>
>>> I didn't tested current master.git - my bad. It is not outdated :)
>>>
>>> Beside, the wiki should be corrected. If you enable 64bit, it will ne=
ed
>>> extents too.
>>>
>>> Are there any existing tools for error injection for file systems?
>>> Random read error from libata or silent data corruptions?
>>>
>>
>> I was playing with metadata_csum trying to kill my system and now i ha=
ve
>> some questions:
>>
>> first the test:
>> #find block number
>> sudo ./debugfs/debugfs -R "imap <3991825>" /dev/sdf1
>>
>> #copy block
>> sudo dd if=3D/dev/sdf1 bs=3D4K count=3D1 skip=3D15958163 of=3Dcorrupt_=
block.bin
>>
>> #change one byte
>> ghex corrupt_block.bin
>>
>> #kill inode
>> sudo dd of=3D/dev/sdf1 bs=3D4K count=3D1 seek=3D15958163 if=3Dcorrupt_=
block.bin
>>
>> sudo ./debugfs/debugfs -R "stat <3991825>" /dev/sdf1
>> #stat: Inode checksum does not match inode while reading inode 3991825=

>>
>> so, inode is corrupt:
>> - ext4 can detect inode corruption. Great work! I like it :)
>> - in this case file will not be shown by Nautilus.
>> - ls will show some thing like this:
>>
>> 4130898 drwx------  8 oleksij oleksij      4096 Jan 17 09:31 Bilder
>>       ? -?????????  ? ?       ?               ?            ?
>> ich-einfach_unverbesserlich_2.mkv
>> 3991826 -rw-rw-r--  1 oleksij oleksij 622038707 Jan 17 11:12 igor.mkv
>> 3989506 drwxr-xr-x 26 oleksij oleksij      4096 Okt  9 23:11 linux
>>
>> it means, i know there is some thing wrong, but i do not know which in=
ode
>=20
> Unfortunately, either the whole stat call succeeds or it doesn't.  Your=
 best
> bet to find the inode is:
> debugfs -n -R 'stat /path/within/fs' /dev/sdXXX

Ok, looks like user space apps should handle errors in different whey. I
mean some thing like, show notification about probable FS errors and so o=
n.

>> - If fs is not fixed, file is lost? are blocks still allocated to this=

>> inode?
>=20
> Yes, the blocks are still allocated.
>=20
>> - debufs will not allow me to edit inode corrupt inode.
>=20
> debugfs -n (disables checksum verification)
>=20
>> - If i run fsck -y file is lost. Most user wont be able to recover it.=

>=20
> If you answer 'n' to the first prompt about the checksum failure, e2fsc=
k will
> check the rest of the inode.  If no other problems are found, it'll ask=
 to
> correct the checksum.
>=20
> I've wondered if perhaps e2fsck ought to do something like this when th=
ere's a
> checksum problem:
>=20
> 1. If the user didn't prohibit clearing the inode as the first potentia=
l
>    action, ask if e2fsck should just clear the inode.
> 2. If not, run the regular checks.
> 3. If there's still a checksum error, ask to fix the checksum.
> 4. If the user doesn't want to fix it, ask to clear the inode.

sounds good.

> iow, e2fsck --verify-checksums-last /dev/sdXX

this mean?

PS: More testing results from today. GRUB fails to install if
metadata_csum enabled. Should it be reported to GRUB devs?

--=20
Regards,
Oleksij


--xF65QrD0ArGt4w5O8DcVF1wWAgiUdI60K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLZjt8ACgkQHwImuRkmbWnBwAD+I87lKEbYF5to/z79pahkQGN7
q7mJbdO43+MRfcK/VFsA/1XEWqaKRypGt8L8w+WUvriBMwej4x/nFzF1867+fOTS
=2gEs
-----END PGP SIGNATURE-----

--xF65QrD0ArGt4w5O8DcVF1wWAgiUdI60K--
