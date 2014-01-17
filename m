From: Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: What is status of metadata_csum
Date: Fri, 17 Jan 2014 11:39:07 +0100
Message-ID: <52D9084B.8030501@rempel-privat.de>
References: <52D7BB10.5090003@rempel-privat.de> <20140117020009.GL9229@birch.djwong.org> <52D8E755.6030205@rempel-privat.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rmWiKbde63nnq06xMb17LE70q1DW0Mae9"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51265 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaAQKjO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jan 2014 05:39:14 -0500
Received: from [192.168.1.100] ([93.218.75.192]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LjJCt-1VUDux4AQx-00daR7 for
 <linux-ext4@vger.kernel.org>; Fri, 17 Jan 2014 11:39:13 +0100
In-Reply-To: <52D8E755.6030205@rempel-privat.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rmWiKbde63nnq06xMb17LE70q1DW0Mae9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.01.2014 09:18, schrieb Oleksij Rempel:
> Am 17.01.2014 03:00, schrieb Darrick J. Wong:
>> On Thu, Jan 16, 2014 at 11:57:20AM +0100, Oleksij Rempel wrote:
>>> What is metadata_csum status?
>>>
>>> i see there are benchmark updates on wiki page, but no updates for
>>> e2fsprogs. 1.43-WIP seems to be really old.
>>
>> Still waiting for 1.43.  I don't know if there are early adopters runn=
ing
>> 1.43-WIP without complaint, or if simply nobody's using it at all. :/
>=20
> I didn't tested current master.git - my bad. It is not outdated :)
>=20
> Beside, the wiki should be corrected. If you enable 64bit, it will need=

> extents too.
>=20
> Are there any existing tools for error injection for file systems?
> Random read error from libata or silent data corruptions?
>=20

I was playing with metadata_csum trying to kill my system and now i have
some questions:

first the test:
#find block number
sudo ./debugfs/debugfs -R "imap <3991825>" /dev/sdf1

#copy block
sudo dd if=3D/dev/sdf1 bs=3D4K count=3D1 skip=3D15958163 of=3Dcorrupt_blo=
ck.bin

#change one byte
ghex corrupt_block.bin

#kill inode
sudo dd of=3D/dev/sdf1 bs=3D4K count=3D1 seek=3D15958163 if=3Dcorrupt_blo=
ck.bin

sudo ./debugfs/debugfs -R "stat <3991825>" /dev/sdf1
#stat: Inode checksum does not match inode while reading inode 3991825

so, inode is corrupt:
- ext4 can detect inode corruption. Great work! I like it :)
- in this case file will not be shown by Nautilus.
- ls will show some thing like this:

4130898 drwx------  8 oleksij oleksij      4096 Jan 17 09:31 Bilder
      ? -?????????  ? ?       ?               ?            ?
ich-einfach_unverbesserlich_2.mkv
3991826 -rw-rw-r--  1 oleksij oleksij 622038707 Jan 17 11:12 igor.mkv
3989506 drwxr-xr-x 26 oleksij oleksij      4096 Okt  9 23:11 linux

it means, i know there is some thing wrong, but i do not know which inode=


- If fs is not fixed, file is lost? are blocks still allocated to this
inode?
- debufs will not allow me to edit inode corrupt inode.
- If i run fsck -y file is lost. Most user wont be able to recover it.
- how can i sync it with back up software?





--=20
Regards,
Oleksij


--rmWiKbde63nnq06xMb17LE70q1DW0Mae9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLZCFAACgkQHwImuRkmbWl5TQD/WRK8Vx0GQVoCWNKyG20UG/gV
hzmUCU+VOOMg1LVFJT0A/i0D+MDFA9+bqKykfRlHDtunwpBTyW/79v6Kqo54pJNe
=aFYa
-----END PGP SIGNATURE-----

--rmWiKbde63nnq06xMb17LE70q1DW0Mae9--
