From: Nathaniel W Filardo <nwf@cs.jhu.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Thu, 10 Apr 2014 01:04:28 -0400
Message-ID: <20140410050428.GV10985@gradx.cs.jhu.edu>
References: <20140409223820.GU10985@gradx.cs.jhu.edu>
 <CAGagf4eEzY4+3cfNWSEENTo1PKe40nq1Ne6ZzOLGm-O78W7RcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lBR2yNlwcY132B3M"
Cc: Mike Rubin <mrubin@google.com>, Frank Mayhar <fmayhar@google.com>,
	admins@acm.jhu.edu, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blaze.cs.jhu.edu ([128.220.13.50]:43859 "EHLO blaze.cs.jhu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaDJFhw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 01:37:52 -0400
Content-Disposition: inline
In-Reply-To: <CAGagf4eEzY4+3cfNWSEENTo1PKe40nq1Ne6ZzOLGm-O78W7RcA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--lBR2yNlwcY132B3M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 10:55:48PM -0400, Theodore Tso wrote:
> Hi Nathaniel,
>=20
> In general, it's best if you send these sorts of requests for help to the
> linux-ext4@vger.kernel.org mailing list.

Added to CC.

> The fact that we see the "error count" line early in the boot message
> suggests to me that your VM is not running fsck to fix up the errors befo=
re
> mounting the file system.  (Well, either that or you're using a really
> ancient version of e2fsck, but given that you're using a bleeding edge
> kernel, but I'm guessing you're using a reasonably recent version of
> e2fsck.  But that would be good for you to check.)

e2fsck version is 1.42.9 using the same library version.
=20
> The ext4 error message is due to the file system getting corrupted.  How
> the file system got corrupted isn't 100% clear, but one potential cause is
> how the disk is configured with qemu.
>[snip]

We use QEMU directives like

        -drive format=3Draw,file=3Drbd:rbdafs-mirror/mirror-0,id=3Ddrive5,i=
f=3Dnone,cache=3Dwriteback \
        -device driver=3Dide-hd,drive=3Ddrive5,discard_granularity=3D512,bu=
s=3Dahci0.3

We've never had, so far as I know, an unexpected shutdown of the QEMU
process, so I don't think that unexpected loss of cache contents is to
blame.

Perhaps the dmesg I sent was not representative; some days ago, we saw, only
(comparatively!) late in the machine's uptime:

[309894.428685] EXT4-fs (sdd): pa ffff88000d9f9440: logic 832, phys.  95745=
8972, len 192
[309894.430023] EXT4-fs error (device sdd): ext4_mb_release_inode_pa:3729: =
group 29219, free 192, pa_free 191
[309894.431822] Aborting journal on device sdd-8.
[309894.442913] EXT4-fs (sdd): Remounting filesystem read-only

with Debian kernel 3.13.5-1; sdd here is the same filesystem as in the
earlier dmesg.

I'll capture any subsequent crashes and follow up.

Thanks much!
--nwf;

--lBR2yNlwcY132B3M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlNGJlwACgkQTeQabvr9Tc/m0gCfV8i4mYUgEGbKP4o5toN/Oq9j
tbQAn24yMZ85ezu95SLjBO6CU9JrZoor
=NLyi
-----END PGP SIGNATURE-----

--lBR2yNlwcY132B3M--
