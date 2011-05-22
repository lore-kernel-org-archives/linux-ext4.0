From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: ext4 and dir_index optimization
Date: Sun, 22 May 2011 14:52:37 +0200
Message-ID: <20110522125237.GC2176@nik-comp.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Cc: nikola.ciprich@linuxbox.cz,
	Petr =?iso-8859-1?Q?Kopeck=FD?= <petr.kopecky@linuxbox.cz>
To: linux ext4 list <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ip-85-135-19-82.customer.poda.cz ([85.135.19.82]:59660 "EHLO
	nik-comp.lan" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755256Ab1EVNZl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 09:25:41 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello everybody,

I'd like to ask few questions about dir_index on ext4. On one of my servers
running 2.6.32.14, we were experiencing performance problems, especially
accessing directory with huge (hundreds of thousands) amount of files
was pain. The filesystem had dir_index enabled, so I tried running fsck
-D on it in order to force reindexation. It helped A LOT - ls -1 on this
directory took about 5 minutes, after reindexation, it took about 10
seconds!
So my question is - is it really needed to force reindexation from time
to time? I'm pretty sure dir_index has been enabled since the creation of
filesystem, so shouldn't index be maintained automatically?
Is it possible to check somehow whether optimization is needed, without
umounting fs and running fsck? And possibly also do this optimization?

Thanks a lot in advance!

Cheers!

nik



--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3ZBxUACgkQ3xdJJrLygV7b4gCgigRArbJDTluxiKNsf1xaDQnk
ntQAnRboD32Wr92R/9+KI1pKoSrzXSgg
=b+JO
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
