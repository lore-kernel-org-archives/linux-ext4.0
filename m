From: Bernd Schubert <bschubert@ddn.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Mon, 25 Oct 2010 22:37:12 +0200
Message-ID: <4CC5EA78.1010005@ddn.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com> <4CC45318.3080002@ddn.com> <4CC45590.80608@redhat.com> <4CC45BFB.4010403@ddn.com> <4CC46241.8070107@redhat.com> <2D4557FB-DE12-43C3-A277-EE4DD82F0BFF@oracle.com> <4CC5DDC5.7080003@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig715EC51A0749D3B2C7E6E455"
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.datadirectnet.com ([74.62.46.229]:40860 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab0JYUhX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 16:37:23 -0400
In-Reply-To: <4CC5DDC5.7080003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------enig715EC51A0749D3B2C7E6E455
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/25/2010 09:43 PM, Eric Sandeen wrote:
>=20
> Now, extN has this feature of recording fs errors in the superblock,
> but I'm not sure we distinguish between "errors which require a fsck"
> and others?

That is definitely a good question - is it right to set a generic error
flag, if 'only' I/O errors came up?  The problem is that the error flag
comes from ext4_error() and ext4_abort(), which are all over the code
and which do not make any difference if it just an IO error or real
filesystem issue.

>=20
> Anyway your characterization of xfs is wrong, IMHO, it's:
>=20
> Mount (possibly replaying the journal) because all should be well,
> we have faith in our hardware and our software.
> If during runtime the fs encounters a severe metadata error, it will
> shut down, and this is your cue to unmount and run xfs_repair, then
> remount.  Doesn't seem backwards to me.  ;)  Requiring that fsck
> prior to the first mount makes no sense for a journaling fs.
>=20
> However, Bernd's issue is probably an issue in general with XFS
> as well (which doesn't record error state on-disk) - how to quickly
> know whether the filesystem you're about to mount in a cluster has
> a -known- integrity issue from a previous mount and really does
> require a fsck.
>=20
> For XFS, you have to have monitored the previous mount, I guess,
> and watched for any errors the kernel threw when it encountered them.


It really would be helpful, if filesystems would provide a health file
as Lustre does. A generic VFS proc/sys file or IOCTL would be helpful,
to have a generic interface. I probably should write a patch for it ;)

Cheers,
Bernd


--------------enig715EC51A0749D3B2C7E6E455
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzF6ngACgkQqh74FqyuOzTQtwCgthXwJ5asDH7XWy8aGiQAUnkg
GZQAoIilDy1tEMYOcZcO6zlIm7e8Vk1l
=Qvgl
-----END PGP SIGNATURE-----

--------------enig715EC51A0749D3B2C7E6E455--
