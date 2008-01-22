From: Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Mon, 21 Jan 2008 23:17:18 -0500
Message-ID: <3673.1200975438@turing-police.cc.vt.edu>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int>
            <20080122033830.GR155259@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200975438_28155P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42793 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYAVERp (ORCPT
	<RFC822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2008 23:17:45 -0500
In-Reply-To: Your message of "Tue, 22 Jan 2008 14:38:30 +1100."
             <20080122033830.GR155259@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1200975438_28155P
Content-Type: text/plain; charset=us-ascii

On Tue, 22 Jan 2008 14:38:30 +1100, David Chinner said:

> Perhaps instead of swapping immediately, a SIGLOWMEM could be sent
> to a processes that aren't masking the signal followed by a short
> grace period to allow the processes to free up some memory before
> swapping out pages from that process?

AIX had SIGDANGER some 15 years ago.  Admittedly, that was sent when
the system was about to hit OOM, not when it was about to start swapping.

I suspect both approaches have their merits...

--==_Exmh_1200975438_28155P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHlW5OcC3lWbTT17ARAqnbAKC9s7T5o1iXU/l9vXOafv6Mjf8NVgCggaW4
6jcH0uv/kcCFYTQb7gBeYyU=
=lQUZ
-----END PGP SIGNATURE-----

--==_Exmh_1200975438_28155P--
