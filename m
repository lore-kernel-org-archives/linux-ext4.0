From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] ext2: do not register write_super within VFS
Date: Wed, 11 Apr 2012 14:24:34 +0300
Message-ID: <1334143474.13842.0.camel@sauron.fi.intel.com>
References: <1333446558-28171-1-git-send-email-dedekind1@gmail.com>
	 <20120403223632.GA5288@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NymKE9nrLlawZPeWzkX1"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12428 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2DKLVu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 07:21:50 -0400
In-Reply-To: <20120403223632.GA5288@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-NymKE9nrLlawZPeWzkX1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-04-04 at 00:36 +0200, Jan Kara wrote:
> On Tue 03-04-12 12:49:18, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >=20
> > Jan Kara removed 'sb->s_dirt' VFS flag references, so we do not need to
> > register the ext2 'ext2_write_super()' method in the VFS superblock ope=
rations,
> > because 'sb->s_dirt' won't be ever set to 1 and VFS won't ever call
> > '->write_super()' anyway. Thus, remove the method.
> >=20
> > Tested using xfstests.
> >=20
> > Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>   Thanks. Added to my tree.

Jan, I do not see this patch in 'for_next' of your tree.

--=20
Best Regards,
Artem Bityutskiy

--=-NymKE9nrLlawZPeWzkX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPhWnyAAoJECmIfjd9wqK0LuMP+gPmVxIEz0+8b2WsUrZEFOjR
Hz6GCx6X/Ws4rdppgCmF/SM3hPuY+Y59E+7KGYUg36TZcF3tZp5/KTuGdU8DTHb/
g98AbaNXjrE6uKLzZkCuzTy21k5mrA0YrkiRhhxhtKxiXa2dRmYvQgQVp0j6cdN5
PomC/rAcC6VCHy7MXOUQXcEfV2pWe95rmXY70qFBGMAUwOLCfsCj9GD0SAxrKedW
MLw8GnpwYKUDzrPxsgaeYEJPGXmZb3qU6+xLHPqoiYa4JmGeerj/K5e2Fkc5S0ab
wdMS2rHLT6MS/xuFM3uE4UqEOQH0Zok5RA9Hqfa+Hg8njaRoJvJvvmpTirIJE3yB
i7wR6bV+E24fNocFAhgRx6AyRfrkPoNUw5Ps6MiCfCqMKC7Ujj0r7PvQqlSecWVe
SDYV122lAxCXaCwhFsggBXmoEMFqkxyXCLjCLOXtOHPVJbYSMA+PfDNBLgk9yueN
83zdnKlp0vfTSz2lIxSl+hMwezKAl/i450k3KwUqDMxly+hSkKTARKtKpJQcldwq
WXNXOaO1hWTEESx+vyaKnDhxoesfSA8171TUBgr6qmQYzSK3cvWGzXhFTDHWyiiE
KCJi/mdjRRt+rek2uVMnHF9Dv+7w/fGTbm7hQbM3+ME5U8f+1cB46VVbWK2+CwfC
Q2f6N56qRE3C6KHLEeeg
=tqn1
-----END PGP SIGNATURE-----

--=-NymKE9nrLlawZPeWzkX1--

