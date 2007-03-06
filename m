From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Tue, 06 Mar 2007 06:36:09 -0800
Message-ID: <45ED7C59.4050508@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz> <45EC7773.7020603@us.ibm.com> <20070306072850.GA23081@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1892E0C32A25A7EFC2025B6B"
To: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, nscott@aconex.com,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com, Ulrich Drepper <drepper@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084AbXCFOh7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2007 09:37:59 -0500
In-Reply-To: <20070306072850.GA23081@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1892E0C32A25A7EFC2025B6B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig wrote:
> fallocate with the whence argument and flags is already quite complicat=
ed,
> I'd rather have another call for placement decisions, that would
> be called on an fd to do placement decissions for any further allocatio=
ns
> (prealloc, write, etc)

Yes, posix_fallocate shouldn't be made more complicated.  But I don't
understand why requesting linear layout of the blocks should be an
option.  It's always an advantage if the blocks requested this way are
linear on disk.  So, the kernel should always do its best to make this
happen, without needing an additional option.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig1892E0C32A25A7EFC2025B6B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF7XxZ2ijCOnn/RHQRAsMhAKDBrHJkvkZUHExGPidVYnuNhLCcZQCfb5lZ
qX3NSLUZ509TmALajVw+/Bs=
=bhNM
-----END PGP SIGNATURE-----

--------------enig1892E0C32A25A7EFC2025B6B--
