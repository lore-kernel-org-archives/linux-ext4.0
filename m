From: Andre Noll <maan@systemlinux.org>
Subject: Re: Problems with checking corrupted large ext3 file system
Date: Fri, 5 Dec 2008 20:23:59 +0100
Message-ID: <20081205192359.GV17966@skl-net.de>
References: <20081203101100.GO17966@skl-net.de> <20081204000936.GE3186@webber.adilger.int> <20081204163759.GR17966@skl-net.de> <20081204195138.GA1323@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BlkQeOBdElZ1aiuH"
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:34349 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbYLETjj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Dec 2008 14:39:39 -0500
Content-Disposition: inline
In-Reply-To: <20081204195138.GA1323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--BlkQeOBdElZ1aiuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:51, Theodore Tso wrote:
> On Thu, Dec 04, 2008 at 05:37:59PM +0100, Andre Noll wrote:
> > OK, so I guess I would like to run e2fsck again without cloning those
> > blocks.
>=20
> Actually, what you should probably do is to take a look at the inodes
> which were listed in the pass1b, and if they don't make sense, to
> clear them out.  An individual inode can be cleared by using the
> debugfs clri command.  i.e., to zero out inode 12345, you do this:
>=20
> debugfs -w /dev/mapper/thunk-closure
> debugfs: clri <12345>
> debugfs: quit
>=20
> This doesn't work very easily if there is a large number of inodes
> that contain garbage, though.

That number is larger than the number of lines in the scrollback
buffer of my screen session...

> I don't have tools that deal well with wholeslae corruption of large
> portions of the inode table, mostly because those tools, if misused,
> could actually cause a lot more harm than good, and so designing the
> proper safety mechanism so they are safe to use in the hands of system
> administrators that are not filesystem experts and tend to use
> commands like "fsck -y" is very difficult to get right.

What are the alternatives to using -y? Today I interrupted the e2fsck
and started the patched version without -y. The first thing it did
was to ask me

	Group descriptor 53702 checksum is invalid.  Fix<y>

I typed "y" perhaps 100 times. Then I gave up and reran the command
with the -y switch.

Wouldn't it be nice if e2fsck gave the user not only the option to
fix or not fix the problem, but also the option to always answer
"yes" to _that particular question_, just in case e2fsck later wants
to ask the same question again.

Another useful feature for the clueless admin would be a short
description of the problem at hand, probably together with a severity
indicator and a hint about how safe it is to answer "yes" at this
point and which alternatives there are. Something in the spirit of
Knuth's TeX messages perhaps :)

> If you're convinced that all of the inode tables greater than 4TB have
> been corrupted, or blocks from a particular physical volume are *all*
> toast, onesolution is to zero out all of the damaged blocks, on the
> theory that there's nothing to save anyway, and e2fsck is trying hard
> to save all possible data --- and if you know there's nothing to save
> there, clearing the parts of the inode table that ar eknown to be bad,
> will make e2fsck run more cleanly.

Unfortunately I have no idea which inode tables might be corrupted. The
PVs containing the corrupted ext3 file system reside entirely on a
24 x 1T Areca raid system which is split into two raid6 volumes. So
Linux sees two ~10T devices which are used as PVs for LVM. The LV
containing the corrupted file system was created with --stripes 2 so
that all 24 disks are used.

That setup worked fine for two months. The raid system started to
crash and fail disks soon after we added a 16 x 1T JBOD extension
unit. We've lost 11(!) disks during one month but no more than two in
a single raid set at any given time. Four of these 11 disk failures
happened to be bogus, i.e. we could fix the problem simply by pulling
and re-inserting the "failed" disks. The event log of the raid system
also contained quite a lot of timeout messages for various disks.

Unfortunately, at the time these problems started to show up, the
16T of the JBOD unit had been added to the VG already (configured
as a single raid6). However, we've only used the additional space to
enlarge _another_ file system in the same VG.

> > > One option is to use the Lustre e2fsprogs which has a patch that tries
> > > to detect such "garbage" inodes and wipe them clean, instead of trying
> > > to continue using them.
> > >=20
> > > 	http://downloads.lustre.org/public/tools/e2fsprogs/latest/
> > >=20
> > > That said, it may be too late to help because the previous e2fsck run
> > > will have done a lot of work to "clean up" the garbage inodes and they
> > > may no longer be above the "bad inode threshold".
> >=20
> > I would love to give it a try if it gets me an intact file system
> > within hours rather than days or even weeks because it avoids the
> > lengthy algorithm that clones the multiply-claimed blocks.
>=20
> Well, it's still worth a shot.
>=20
>=20
> > As the box is running a Ubuntu, I could not install the rpm directly.
> > So I compiled the source from e2fsprogs-1.40.11.sun1.tar.gz which is
> > contained in e2fsprogs-1.40.11.sun1-0redhat.src.rpm. gcc complained
> > about unsafe format strings but produced the e2fsck executable.
> >=20
> > Do I need to use any command line option to the patched e2fsck? And
> > is there anything else I should consider before killing the currently
> > running e2fsck?
>=20
> Nope, try it and let us know whether it seems to work.

It completed within 5 hours. During this time it printed many messages
of the form

	Inode 132952070 has corrupt indirect block
	Clear? yes

and

	Inode 132087812, i_blocks is 448088, should be 439888.  Fix? yes

Also a couple of these are contained in the output:

	Too many illegal blocks in inode 132952070.
	Clear inode? yes

After 5 hours, it printed the "Restarting e2fsck from the
beginning..." message just like the unpatched version. It's now at 45%
in the second run with no further messages so far. In particular, there
are no more "clone multiply-claimed blocks" messages.  I'm leaving
for the weekend now, but I'll send another mail on Monday.

Thanks for your help, I really appreciate it.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--BlkQeOBdElZ1aiuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJOX/PWto1QDEAkw8RAoqLAJ9NtxpGImJvHdPpHeUpzJEiibYEfgCdHowb
/wO9oC78t5K+JttWyt6qF4g=
=IygP
-----END PGP SIGNATURE-----

--BlkQeOBdElZ1aiuH--
