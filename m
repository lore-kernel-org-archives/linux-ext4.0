From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Question about ext4 project feature
Date: Thu, 29 Jun 2017 12:18:03 -0600
Message-ID: <0B0D440B-A827-471D-A797-0D94ED8F9F0E@dilger.ca>
References: <1939863a-d866-69ff-f3ab-55692102473e@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C8BC53B9-83C7-43CF-A5D3-D52D2B9E3200";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, miaoxie@huawei.com,
        Jan Kara <jack@suse.cz>, Wang Shilong <wshilong@ddn.com>
To: "zhangyi (F)" <yi.zhang@huawei.com>, Li Xi <lixi@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33280 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdF2SSM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jun 2017 14:18:12 -0400
Received: by mail-io0-f195.google.com with SMTP id z62so1281296ioi.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Jun 2017 11:18:12 -0700 (PDT)
In-Reply-To: <1939863a-d866-69ff-f3ab-55692102473e@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C8BC53B9-83C7-43CF-A5D3-D52D2B9E3200
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 29, 2017, at 4:46 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>=20
> Hi All:
>=20
> I find a problem when I use project quota, my base environment is
> radhat7.2 (kernel-3.10.y + e2fsprogs-1.42.9).
>=20
> It will be reproduced with the following steps:
> 1. mkfs.ext4 /dev/vdb1
> 2. mount /dev/vdb1 /mnt
> 3. touch /mnt/testfile
> 4. umount /mnt
> 5. Update kernel and e2fsprogs to *upstream stable version*
> 6. tune2fs -O quota,project /dev/vdb1
> 7. mount /dev/vdb1 /mnt
> 8. chattr -p 123 /mnt/testfile
>=20
> Execute fail and output:
> /bin/chattr: Value too large for defined data type while setting =
project on /mnt/aa
>=20
> The immediate reason is the following check, i_extra_isize is not =
updated.
> static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
> {
> 	...
> 	raw_inode =3D ext4_raw_inode(&iloc);
> 	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
> 		err =3D -EOVERFLOW;
> 		brelse(iloc.bh);
> 		goto out_unlock;
> 	}
> 	...
> }
>=20
> So if I write something to testfile before "step 8" ,the chattr will =
execute
> successfully, because it trigger ext4_expand_extra_isize() to update
> i_extra_isize. So is this a BUG or I miss something?

It looks like this code path should also try to expand i_extra_isize if =
possible,
and only return an error if that fails.

Li Xi, would you be able to look into that?

Cheers, Andreas






--Apple-Mail=_C8BC53B9-83C7-43CF-A5D3-D52D2B9E3200
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZVURdpIg59Q01vtYRAhp9AJ4ynN3kQnT/J7qbG9t/7GYPA6qAWwCfcwHk
8X8hg8D0SY9AxnxnbRVqp5k=
=3FGA
-----END PGP SIGNATURE-----

--Apple-Mail=_C8BC53B9-83C7-43CF-A5D3-D52D2B9E3200--
