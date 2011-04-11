From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: tune2fs can't be used on a mounted ext4, or...?
Date: Tue, 12 Apr 2011 00:55:26 +0600
Message-ID: <20110412005526.3015a238@natsu>
References: <20110410003954.4108b9c9@natsu>
	<14B9D41F-4D38-4F01-97E9-17E86DA578FC@dilger.ca>
	<20110410035005.64f565e3@natsu>
	<20110411131008.GB5802@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fWUOfZni/GhxFfdm=_zylQr"; protocol="application/pgp-signature"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	linux-raid@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110411131008.GB5802@thunk.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/fWUOfZni/GhxFfdm=_zylQr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Apr 2011 09:10:08 -0400
Ted Ts'o <tytso@mit.edu> wrote:

> Your symptoms don't sound familiar to me, other than the standard
> concerns about hardware induced file system inconsistency problems.

Thing is, I do not observe any in-file random data corruptions which would
point to a problem at a lower (block-device) level, so I do not think it is=
 a
RAID or HDD problem.

The breakage seemed to be on the filesystem logic level, perhaps something =
to
do with allocation of space for new files? And since I immediately just bef=
ore
that, made two operations possibly affecting it (tune2fs stride size + onli=
ne
grow with resize2fs) that's why I thought this might be an ext4 problem.

While still in the same session, I then re-copied the affected files replac=
ing
their "shortened" copies, and they were written out fine the second time. A=
nd
after a reboot, no more file truncations are observed so far.

> Have you checked your logs carefully to make sure there weren't any
> hardware errors reported?

No, there weren't any errors in dmesg, or on the same console where 'cp' wo=
uld
output its errors.

> If this is a hardware RAID system, is it  regularly doing disk scrubbing?
> Has the hardware RAID reported anything unusual?  How long have you been
> running in a degraded RAID 6 state?

It is an mdadm RAID6, and it does not report any problem. It was running in=
 a
degraded state for only a short time (less than a day). And AFAIK running
degraded without one disk is not a dangerous or risky situation with RAID6.

> And have you tried shutting down the system and running fsck to make
> sure there weren't any file system corruption problems?  When's the
> last time you've run fsck on the system?

I have unmounted it and ran fsck just now. Admittedly there was a long time
since the last fsck.

# e2fsck /dev/md0
e2fsck 1.41.12 (17-May-2010)
/dev/md0 has gone 306 days without being checked, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md0: 367107/364412928 files (4.3% non-contiguous), 1219229259/14576267=
52
blocks

> If this is an LVM system, I'd strongly suggest that you set aside
> space you can take a snapshot, and then regularly take a snapshot, and
> then run fsck on the snapshot.  If any problems are noted, you can
> then schedule downtime and fsck the entire system.

No, I don't use LVM there.

--=20
With respect,
Roman

--Sig_/fWUOfZni/GhxFfdm=_zylQr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2jTp4ACgkQTLKSvz+PZwhcegCglefgdLAxZ7VhoA3LU4WxW8rr
WBYAn1o5FWEdgBcGbOW8B5pIfhJT1nnC
=r96r
-----END PGP SIGNATURE-----

--Sig_/fWUOfZni/GhxFfdm=_zylQr--
