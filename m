From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Sun, 04 Mar 2007 14:38:13 -0800
Message-ID: <45EB4A55.3060908@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4511FD13B0C471431C6164FA"
Cc: Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbXCDWj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2007 17:39:27 -0500
In-Reply-To: <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4511FD13B0C471431C6164FA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Anton Altaparmakov wrote:
> And that is it.  No zeroing needs to happen at all because we
> have not updated the initialized size of the inode!

When you do it like this, who can the kernel/filesystem *guarantee* that
when the data is written there actually is room on the harddrive?

What you described seems like using truncate/ftruncate to increase the
file's size.  That is not at all what posix_fallocate is for.
posix_fallocate must make sure that the requested blocks on the disk are
reserved (allocated) for the file's use and that at no point in the
future will, say, a msync() fail because a mmap(MAP_SHARED) page has
been written to.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig4511FD13B0C471431C6164FA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF60pV2ijCOnn/RHQRAq90AKCBpxmtH1aGqHnilUSJwpbWdqyMcQCgrmsR
sCXUrS3H64jrSXyso5i4r4o=
=ia33
-----END PGP SIGNATURE-----

--------------enig4511FD13B0C471431C6164FA--
