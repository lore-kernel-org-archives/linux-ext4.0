From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv3 3/4] ext4: remove unnecessary superblock dirtying
Date: Wed, 04 Jul 2012 15:25:40 +0300
Message-ID: <1341404740.2979.91.camel@sauron.fi.intel.com>
References: <1341316810-22598-1-git-send-email-dedekind1@gmail.com>
	 <1341316810-22598-4-git-send-email-dedekind1@gmail.com>
	 <20120703124804.GC27388@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7mcIvle6Qt9sbNIqsyc3"
Cc: Theodore Tso <tytso@mit.edu>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2GDMWh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jul 2012 08:22:37 -0400
In-Reply-To: <20120703124804.GC27388@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-7mcIvle6Qt9sbNIqsyc3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-03 at 14:48 +0200, Jan Kara wrote:
> > 1. When creating the first large file on a file
> >    system without EXT4_FEATURE_RO_COMPAT_LARGE_FILE feature.
> > 2. When re-sizing the file-system
> > 3. When creating an xattr on a file-system without the
> >    EXT4_FEATURE_COMPAT_EXT_ATTR feature.
>   Since this was written, we seem to have grown a use of
> ext4_handle_dirty_super() in fs/ext4/namei.c when adding inode to orphan
> list.

Re-worked the commit message a bit in v4.

> > +		err =3D ext4_commit_super(sb, 0);
>   When you look at the whole __ext4_handle_dirty_super() function now, it
> doesn't make much sense like this. When now =3D=3D 1, we mark superblock =
buffer
> as dirty, when now =3D=3D 0, we set wtime, kbytes_written, free blocks an=
d
> inodes in the superblock buffer and then mark it dirty. Looking into all
> the places calling this, I'd just drop the 'now' argument and make
> everything behave as in now =3D=3D 1 case.

Done in v4 in patch N5. Thanks a lot for suggestions and the help!

--=20
Best Regards,
Artem Bityutskiy

--=-7mcIvle6Qt9sbNIqsyc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP9DZEAAoJECmIfjd9wqK0OC8P/jNo4R0bjsn+9tIVHkpzdKC2
w/xkSu1VzKsCI/os1dhgbbH5Ce2YwmPy0uE3F4+iDp8EgZnvFBtCWIRetZDRGpFZ
cM7xjRYW7DPaPzNP8NbxOkMfhNU70zYFvWGiWzD7aXnk8sbkFcGBbinjCSwbuBQy
1Eu5ULw1Ajy1yRF4vMK8D7dXy4mByFEqQRLCg6brDslyNM0Fgfo0eUe4RJ+bjeUy
pQJuPHwvOu0SekgAWIRgDY5CtcRfr/qb3hk/1dARJTNOFvken9JN9BTwjq8KNGyi
aqxTVn3oZLyZmraTlTXuSPgHsrvLS3zlhHwWxBu9y+o8a/+9+EHmxyYjX45NKanj
+swcsvPxVtsLtw6YYat4S0y/EWPx8gs644e/b5FIVlyVLLboc0oGX3/1o90/BKJM
IH4NMjtuR15XTl9ccFem9Mu/agV/3fbP4RwIDd/+coC5o0ybq7tAJePAcovpww7C
88rUtDLvbu8sOQQz6f3fRsUTBetvJcVeJQeyzj51/ndLLH1by+f8LeL5oQtIoBVZ
KfxpolQmuKNqD0rggIq+tVgrCI8vRjQURNZvd2/dxtZylXvLZBNKJ2eYnhFGMthd
hhApc65hNMx7gjV4GinrN7ABDqwhMKB2QSqlYAD8ypdejez8St3ucHj3Qa0n/5mt
hWlqWVZY5s9RaX871Y9W
=IqDP
-----END PGP SIGNATURE-----

--=-7mcIvle6Qt9sbNIqsyc3--

