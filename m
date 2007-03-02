From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 23:09:00 -0800
Message-ID: <45E7CD8C.6040908@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>	<20070225022326.137b4875.akpm@linux-foundation.org>	<20070301183445.GA7911@amitarora.in.ibm.com>	<20070301142537.b5950cd7.akpm@linux-foundation.org>	<1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301145949.3efac328.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC2E015409181A2640213885F"
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422909AbXCBHMI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2007 02:12:08 -0500
In-Reply-To: <20070301145949.3efac328.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC2E015409181A2640213885F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Perhaps Ulrich can comment.

I was out of town, hence the delay.

I think that if there is no support for the syscall the correct answer
is to return ENOSYS.  In this case the current userlevel code would be
used and ENOSYS is also used to trigger the use of the compat code in
glibc in case the syscall does not exist at all.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigC2E015409181A2640213885F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF582M2ijCOnn/RHQRAoQOAJ9Rp7RD6N5GQXiyypFz29BnOcGpxwCeIKO+
UCDUfmTcACHjHep2Jv+Zr60=
=agIK
-----END PGP SIGNATURE-----

--------------enigC2E015409181A2640213885F--
