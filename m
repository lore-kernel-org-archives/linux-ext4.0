From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: First stab at ea inode disk format doc updates
Date: Thu, 29 Jun 2017 17:50:04 -0600
Message-ID: <E25342D9-DF52-460C-9260-7EF7D19A7774@dilger.ca>
References: <20170622181856.GD4728@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C71BC025-33F2-4776-8766-45E2DEC1C0AF";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Tahsin Erdogan <tahsin@google.com>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:32815 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdF2XuJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jun 2017 19:50:09 -0400
Received: by mail-io0-f196.google.com with SMTP id z62so1873686ioi.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Jun 2017 16:50:08 -0700 (PDT)
In-Reply-To: <20170622181856.GD4728@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C71BC025-33F2-4776-8766-45E2DEC1C0AF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 22, 2017, at 12:18 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> I've taken a first stab at capturing the on-disk format updates for ea
> inodes.  Let me know about any inaccuracies (though being a wiki, you
> can fix them yourself if you're so inclined).
>=20
> Also -- what is the value of i_mtime (ea inode parent pointer) when =
the
> refcount > 1?

Thanks for the update Darrick.  I clarified that i_mtime/i_generation is
only for refcount =3D=3D 1.  I don't know if the current code will clear =
these
values if refcount > 1 or not, or if they are just unused in that case?

> [1] https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout


Cheers, Andreas






--Apple-Mail=_C71BC025-33F2-4776-8766-45E2DEC1C0AF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZVZIspIg59Q01vtYRAoAUAKDZ2cEor8wUqDpFJvH+AMAKYhnhOwCg55S5
K1yluhmfhIf5yk76d2mM7tc=
=AzKY
-----END PGP SIGNATURE-----

--Apple-Mail=_C71BC025-33F2-4776-8766-45E2DEC1C0AF--
