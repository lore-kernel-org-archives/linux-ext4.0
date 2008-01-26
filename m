From: Zan Lynx <zlynx@acm.org>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Fri, 25 Jan 2008 17:55:12 -0700
Message-ID: <1201308912.7784.6.camel@localhost>
References: <9Mo9w-7Ws-23@gated-at.bofh.it> <9OdWm-7uN-25@gated-at.bofh.it>
	 <9Oi9A-5EJ-3@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it>
	 <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it>
	 <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
	 <20080124230809.GA29120@does.not.exist> <20080124234037.GJ15858@mit.edu>
	 <1201220742.7557.10.camel@localhost>
	 <20080125110942.GX18433@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8OvqBAtkr4HvXMMKWXpO"
Cc: Theodore Tso <tytso@MIT.EDU>, Adrian Bunk <bunk@kernel.org>,
	Bodo Eggert <7eggert@gmx.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ric Wheeler <ric@emc.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from threatwall.zlynx.org ([199.45.143.218]:33126 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbYAZA4E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2008 19:56:04 -0500
In-Reply-To: <20080125110942.GX18433@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-8OvqBAtkr4HvXMMKWXpO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-01-25 at 04:09 -0700, Andreas Dilger wrote:
> On Jan 24, 2008  17:25 -0700, Zan Lynx wrote:
> > Have y'all been following the /dev/mem_notify patches?
> > http://article.gmane.org/gmane.linux.kernel/628653
>=20
> Having the notification be via poll() is a very restrictive processing
> model.  Having the notification be via a signal means that any kind of
> process (and not just those that are event loop driven) can register
> a callback at some arbitrary point in the code and be notified.  I
> don't object to the poll() interface, but it would be good to have a
> signal mechanism also.

The commentary on the mem_notify threads claimed that the signal is
easily provided by setting up the file handle for SIGIO.

Yeah.  Here it is...copied from email written by KOSAKI Motohiro:

implement FASYNC capability to /dev/mem_notify.

<usage example>
        fd =3D open("/dev/mem_notify", O_RDONLY);

        fcntl(fd, F_SETOWN, getpid());

        flags =3D fcntl(fd, F_GETFL);
        fcntl(fd, F_SETFL, flags|FASYNC);  /* when low memory, receive SIGI=
O */
</usage example>
--=20
Zan Lynx <zlynx@acm.org>

--=-8OvqBAtkr4HvXMMKWXpO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHmoTwG8fHaOLTWwgRAqrUAJ9BqPjzdrwVehS2K6X740ZhufJk1wCfVj8U
jWxnklmPauoBzUVuXxKKUjE=
=YOk3
-----END PGP SIGNATURE-----

--=-8OvqBAtkr4HvXMMKWXpO--
