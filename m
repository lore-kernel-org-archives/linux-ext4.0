From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4 inode destroy
Date: Wed, 4 Jan 2017 15:00:18 -0700
Message-ID: <615EEA1E-99FC-49BD-A6CD-FD58D4713B2E@dilger.ca>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com> <141922.1483225153@turing-police.cc.vt.edu> <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com> <20170104215424.GB14021@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D54C3496-E4F2-4A0A-A6D0-BFAF8B6CE14A"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, Valdis.Kletnieks@vt.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33515 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935516AbdADWAY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2017 17:00:24 -0500
Received: by mail-it0-f65.google.com with SMTP id c20so55021803itb.0
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jan 2017 14:00:23 -0800 (PST)
In-Reply-To: <20170104215424.GB14021@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D54C3496-E4F2-4A0A-A6D0-BFAF8B6CE14A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 4, 2017, at 2:54 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Wed, Jan 04, 2017 at 04:29:33PM +0800, zhangyi (F) wrote:
>> On 2017/1/1 6:59, Valdis.Kletnieks@vt.edu said:
>>> On Mon, 26 Dec 2016 20:34:17 +0800, yi zhang said:
>>>> Because of the disk and hardware issue, the ext4 filesystem have
>>>> many errors, the inode->i_nlink of ext4 becomes zero abnormally
>>>> but the dentry is still positive, it will cause memory corruption
>>>> after the following process:
>>>>=20
>>>> 1) Due to the inode->i_nlink is 0, this inode will be added into
>>>> the orhpan list,
>>>=20
>>>> +	if (WARN(inode->i_nlink =3D=3D 0, "inode %lu nlink"
>>>> +		" is already 0", inode->i_ino))
>>>=20
>>> Can we get the filesystem? Or at least the device major/minor? If a =
system
>>> has multiple large ext4 filesystems, it would be helpful to know =
which
>>> one is having the problem.
>>>=20
>>=20
>>        if (WARN(inode->i_nlink =3D=3D 0,
>> -               "inode %lu nlink is already 0", inode->i_ino))
>> +               "inode %lu nlink is already 0, dev=3D%u:%u",
>> +               inode->i_ino, MAJOR(inode->i_sb->s_dev), =
MINOR(inode->i_sb->s_dev)))
>>                return;
>>=20
>> We can modify as above, it's enough to know which filesystem is =
having the
>> problem, what do you think?
>=20
> Why not:
>=20
> if (inode->i_nlink =3D=3D 0) {
> 	ext4_warning_inode(inode, "nlink is already 0");
> 	return;
> }

I like this better as well.

Cheers, Andreas






--Apple-Mail=_D54C3496-E4F2-4A0A-A6D0-BFAF8B6CE14A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWG1wc3Kl2rkXzB/gAQghxhAArladMEqn5neaJeACc35ohvKXhqwy8HP5
KPlWf5DJectpfu/w1e4WXDPPXuGjMLYECuhLQ+ZBHizGzJ5sDtVZVXgN31YNkbHs
UfvihV/5l1G9sgW/wbPm6SH3PVEohbM4y9A0LUC5ljWtVM42itaDe0SGWS3ZohCR
kUU634BtFbLvj8Hye0zQ/7exUgItbDCEfdIkrXi2k4i2m0jLz5oyaWD6NK/9QJco
Itw0Dm3oFfb7bohTKXgEUeGYyRE0yaVbn/XXMY3FmiLK8Cvl/VtZVi/vIlzgSw/m
wSyiWmHHwO/K+Qu4txena+KRV3c+vicTfIKj/MM7JdDUTTJ6AIGwe5lO38QMkSWY
u+hPj//P+4ZgCjRae/wf6vLqKj5nWl3lL+ULUYWPZZIen7YCZ1KrlUhQZH0jFtuy
Am5gjPmb9SRtYfacGOsAS/lz5k1B+l9CLUfGolJhBq99AvrcOpSWLuPgFeAzn0h/
IVuCwwuHw/J+0+NBbH1yKvzLuwK6A6wbPxZRN4W8ZkiMAo8bjF59CQJ788Tq592Q
59hzir4lZI/9vYAtflV12cmvObZKYd2j+d86zFW6g/yzYrJ7P1MSLVHiDGrZ6vw6
XA1DzlipsL7NcmczsDvwHOt4HkuU9NquI0/arsRSjI2zCy+l8HIHGMDRHLx5Gmtf
5RwuhTUm8uI=
=Qtpn
-----END PGP SIGNATURE-----

--Apple-Mail=_D54C3496-E4F2-4A0A-A6D0-BFAF8B6CE14A--
