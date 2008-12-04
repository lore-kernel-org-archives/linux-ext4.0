From: Andre Noll <maan@systemlinux.org>
Subject: Re: Problems with checking corrupted large ext3 file system
Date: Thu, 4 Dec 2008 17:37:59 +0100
Message-ID: <20081204163759.GR17966@skl-net.de>
References: <20081203101100.GO17966@skl-net.de> <20081204000936.GE3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EguBBKnZWdUQS9Kz"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:53957 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbYLDQxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Dec 2008 11:53:16 -0500
Content-Disposition: inline
In-Reply-To: <20081204000936.GE3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--EguBBKnZWdUQS9Kz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:09, Andreas Dilger wrote:
> On Dec 03, 2008  11:11 +0100, Andre Noll wrote:
> > I've some trouble checking a corrupted 9T large ext3 fs which resides
> > on a logical volume. The underlying physical volumes are three hardware
> > raid systems, one of which started to crash frequently. I was able
> > to pvmove away the data from the buggy system, so everything is fine
> > now on the hardware side.
>=20
> A big question is what kernel you are running on.  Anything less than
> 2.6.18-rhel5 (not sure what vanilla kernel) has bugs with ext3 > 8TB.

The box is currently running 2.6.25.20 and was never running a kernel
older than 2.6.23.x. So we should be safe regarding those bugs.

> The other question is whether there is any expectation that the data
> moved from the bad RAID arrays was corrupted.

I can't say for sure but I'd guess the data was already corrupted when
I started the pvmove.

> Running "e2fsck -y" vs. "e2fsck -p" will sometimes do "bad" things because
> the "-y" forces it to continue on no matter what.

True. But running with -p would abort and ask me to run without -p
anyway.

> >         /backup/data/solexa_analysis/ATH/MA/MA-30-29/run_30/4/length_42=
/reads_0.fl (inode #145326082, mod time Tue Jan 22 05:09:36 2008)
> > followed by
> >=20
> > 	Clone multiply-claimed blocks? yes
>=20
> This is likely fallout from the original corruption above.  The bad news
> is that these "multiply-claimed blocks" are really bogus because of the
> garbage in the missing inode tables...  e2fsck has turned random garbage
> into inodes, and it results in what you are seeing now.

OK, so I guess I would like to run e2fsck again without cloning those
blocks.

> I would suggest as a starter to run "debugfs -c {devicename}" and
> use this to explore the filesystem a bit.  This can be done while
> e2fsck is running, and will give you an idea of what data is still
> there.

Very good idea, thanks. We just did this and the important files
seem to be there but some of them, in particular those which were
mentioned in the fsck output, contain garbage or data from other files
in the middle.  So the expensive O(n^2) algorithm indeed seems to be
of little use for our particular case.

> If you think that a majority of your file data (or even just the
> important bits) are available, then I would suggest killing e2fsck,
> mounting the filesystem read-only, and copying as much as possible.

We are considering this, but it also means we have to quickly get 9T
of additional disk space which could turn out to be difficult given the
fact we already borrowed 16T from another department for the pvmove :)

> One option is to use the Lustre e2fsprogs which has a patch that tries
> to detect such "garbage" inodes and wipe them clean, instead of trying
> to continue using them.
>=20
> 	http://downloads.lustre.org/public/tools/e2fsprogs/latest/
>=20
> That said, it may be too late to help because the previous e2fsck run
> will have done a lot of work to "clean up" the garbage inodes and they
> may no longer be above the "bad inode threshold".

I would love to give it a try if it gets me an intact file system
within hours rather than days or even weeks because it avoids the
lengthy algorithm that clones the multiply-claimed blocks.

As the box is running a Ubuntu, I could not install the rpm directly.
So I compiled the source from e2fsprogs-1.40.11.sun1.tar.gz which is
contained in e2fsprogs-1.40.11.sun1-0redhat.src.rpm. gcc complained
about unsafe format strings but produced the e2fsck executable.

Do I need to use any command line option to the patched e2fsck? And
is there anything else I should consider before killing the currently
running e2fsck?

Thanks a lot for your help.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--EguBBKnZWdUQS9Kz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJOAdnWto1QDEAkw8RAjqOAJ0SiOmoZJ65SyKLdl2wSy6QjQtpcACfflpP
9+URZ7CH+fHmRzYBWLbjZgw=
=zbP0
-----END PGP SIGNATURE-----

--EguBBKnZWdUQS9Kz--
