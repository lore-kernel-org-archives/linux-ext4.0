Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44670 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbeKWJGr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Nov 2018 04:06:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id s5-v6so9743838plq.11
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 14:25:21 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <8C93EA0E-D1E2-4045-8B40-B2C34CF3C6BE@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FC03F969-28FF-4EED-A537-F3271E086ECA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] Add block_high_watermark sysfs tunable.
Date: Thu, 22 Nov 2018 15:25:15 -0700
In-Reply-To: <9ba7e5de79b8b25e335026d57ec0640fc25e5ce0.1534905460.git.jaco@uls.co.za>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Jaco Kroon <jaco@uls.co.za>
References: <40D96E04-FFAB-41C5-AD0C-CF15FA0078B0@dilger.ca>
 <9ba7e5de79b8b25e335026d57ec0640fc25e5ce0.1534905460.git.jaco@uls.co.za>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FC03F969-28FF-4EED-A537-F3271E086ECA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 21, 2018, at 8:21 PM, Jaco Kroon <jaco@uls.co.za> wrote:
>=20
> NOT READY FOR MERGE!!!!!!
>=20
> Limiting block allocations to a high watermark will eventually enable =
us
> to perform online shrinks of an ext4 filesystem.  As an immediate
> benefit it'll prevent allocation of blocks in the high range, which if
> performed as a precursor to an offline filesystem shrink will help to
> reduce the overall time a filesystem needs to be taken offline in =
order
> to shrink it.
>=20
> (possible) shortcomings:
>=20
> Currently this tunable does not get stored to the superblock, and thus
> needs to be set again after each mount.
>=20
> The ext4_statfs function doesn't adjust the f_bavail value currently, =
as
> such df will report incorrect results.
>=20
> The inode allocator hasn't been synced yet.

Hi Jaco,
sorry for the extreme delay in replying to this.  It was lost in my =
inbox
and I only just found it now.  Looking through the patch, it does seem =
OK
for the basic functionality intended, and would at least allow you to
reduce the number of blocks allocated at the end of the device, meaning
that the offline shrink would take less time (ideally none if all of the
files are removed from the end of the device).

With this first patch it should be possible to do an "online shrink" by
setting the high watermark, then walking the filesystem checking for any
files have blocks beyond the HWM via "filefrag -v" and running e4defrag
on those files.  This should be largely transparent to userspace.  The
current patch would not allow directly limiting inode allocation, but =
using
the "inode_goal" tunable could be used to influence the inode selection =
to
allow "mkdir + rsync + mv" to move directory trees to lower inodes.  =
Only
files currently open for write would not be safe to move to new inodes.


I think for fully using this functionality in the kernel/e2fsprogs a few
more additions are needed, as you mentioned above:
- store the high watermark in the superblock via tune2fs, so that it is
  not lost if the system is rebooted or filesystem remounted
- fix ext4_statfs() to adjust available blocks appropriately
- avoid allocating inodes in blocks above the high watermark

Typically, using tune2fs to adjust a mounted filesystem should change =
the
value used by the kernel, so also having a /sys tunable gets tricky.  =
One
option would be to leave "sbi->s_block_high_watermark =3D 0" and use the
superblock value if the sbi->s_block_high_watermark =3D=3D 0, and only =
use
sbi->s_block_high_watermark if it is set directly?  Something like:

static inline
ext4_fsblk_t ext4_blocks_max_allocatable(struct ext4_sb_info *sbi)
{
	ext4_fsblk_t blocks =3D ext4_blocks_count(sbi->s_es);

	if (unlikely(sbi->s_block_high_watermark &&
		     sbi->s_block_high_watermark < blocks))
		return sbi->s_block_high_watermark;

	if (unlikely(sbi->s_es->s_blk_high_watermark &&
		     le64_to_cpu(sbi->s_es->s_blk_high_watermark) < =
blocks)
		return le64_to_cpu(sbi->s_es->s_blk_high_watermark);

	return blocks;
}

this adds a bit more runtime overhead vs. setting s_block_high_watermark
from the superblock at mount time, but is more flexible.

For ext4_statfs() do we subtract only the free blocks beyond HWM from =
the
available count, or all blocks?  Subtracting the difference between
ext4_blocks_count() and ext4_blocks_max_allocatable() is easy (zero if =
no
high watermark), but the available blocks should not be negative if =
there
are lots of blocks used beyond the HWM and few free below it.  Better =
would
be if the available blocks would report the free blocks below the HWM,
but this would involve subtracting free blocks above the HWM and =
adjusting
this as blocks above the limit are freed.

For the inode allocation limit, it is fairly straight forward to map the
block HWM to an inode HWM based on the group descriptor that the HWM is =
in.
For future use (dynamic inode tables) it may be desirable to also have a
separately tunable inode HWM, but it could also be done later as needed.

On the e2fsprogs side, there should be a "-E block_high_watermark=3DN" =
tunable
added to set the field in the superblock, and support to print it in =
dumpe2fs
and modify it in dumpe2fs via "ssv".

It may be useful to add a "-f" force flag to e4defrag so that it moves
inodes even if they are not less fragmented afterward, so blocks beyond =
the
HWM are always freed.  Alternately, block and inode move (for closed =
files)
might be implemented in userspace via resize2fs (essentially cp+rename) =
when
it is doing an online shrink of the filesystem?  That might be simpler =
from
a user point of view instead of needing to run e4defrag manuall that =
needs
to be scripted to find the files to be moved.

Optionally, should there be a "hard" and a "soft" block limit?  For =
example,
if the high watermark is set to a negative value -blocks it is a soft =
limit
(prefer lower allocation, but can exceed it if filesystem is full), or =
have
a separate "soft" flag stored somewhere else?  In the first case, we =
should
mask off the high bit when accessing this field, and use it only for =
deciding
if allocation can continue after a normal scan failed.

In the longer term, the resize ioctl could be enhanced to drop the last
group(s) if they are above the high watermark and have no used =
blocks/inodes.
The resize2fs tool could report if trying to shrink a filesystem with =
in-use
blocks that the HWM will be set and file migration is needed, then do =
the
online migration (reporting any files that are open via lsof) and =
returning
an error in the end that which processes are blocking the resize.

Some minor nits in the patch inline below:

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0f0edd1cd0cd..dc30ea107c55 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1423,6 +1423,7 @@ struct ext4_sb_info {
> 	unsigned int s_mb_order2_reqs;
> 	unsigned int s_mb_group_prealloc;
> 	unsigned int s_max_dir_size_kb;
> +	ext4_fsblk_t s_block_high_watermark; /* allocators must not =
allocate blocks above this */

(style) should stay under 80 columns.  Easiest to just shorten comment =
to
something like "/* max allocatable block number */" or similar.

> @@ -2711,6 +2712,15 @@ static inline ext4_fsblk_t =
ext4_blocks_count(struct +static inline ext4_fsblk_t =
ext4_blocks_max_allocatable(struct ext4_sb_info *sbi)
> +{
> +	ext4_fsblk_t blocks =3D ext4_blocks_count(sbi->s_es);

(style) blank line after variable declarations

> +	if (sbi->s_block_high_watermark && sbi->s_block_high_watermark < =
blocks)
> +		return sbi->s_block_high_watermark;
> +	else
> +		return blocks;

(style) no need for "else" after "return".

> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 9212a026a1f1..2a1a955c2c0b 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -304,6 +307,9 @@ static ssize_t ext4_attr_show(struct kobject =
*kobj,
> 		return print_tstamp(buf, sbi->s_es, s_first_error_time);
> 	case attr_last_error_time:
> 		return print_tstamp(buf, sbi->s_es, s_last_error_time);
> +	case attr_block_high_watermark:
> +		return snprintf(buf, PAGE_SIZE, "%llu\n",
> +				(s64) sbi->s_block_high_watermark);

(style) no space after typecast


Cheers, Andreas






--Apple-Mail=_FC03F969-28FF-4EED-A537-F3271E086ECA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlv3LMwACgkQcqXauRfM
H+CjQg//d5ZbsLNTs+uWGOK5QaLCaLmAu+e8eFMofE9nMOb2yWDCQuHzfXGFzzm5
Ee34JZ73Jk5nT2Bp05AxApp0loCq6bK9QDcvf7UvJ4OXzG02oL7zAXPri9m6Y22A
kRF++72KzJogr05Nmg5DG/M2JtksYF+VyULpKPPgHEDgyP+rTNcrMFHwfi3YeUqe
5RIZOMkdYC6t6X8so1X0VJorrhLmcsL7Fyq8VhcyXwhYqm0n65MHEztve+/wXLPo
Ca9yYrIfS1O1ZlomlaDc48sxNcA/8dY64Rz1TBFZcr8j89SznL1KOqpg+qz6R7cI
8WgcOHFEFHz/i71JnSndEv2WcTNxBdPi+egGYan1KN82GSq198r+1r3o82JZDscg
uXIxYojhZbogBgLHTEs5Z11TdWsVkuaHMDJzPBn0zsnrd6i0W48egQuKUdovYgyJ
LJ13LO3Jvickl55UIKybPbUrsU4PYuVYZP1tv0pA8yglZK0YAW+As+Ez3+3OBKmU
hW29oPUz2ejzYOfC8KnPEFDWbH2s5+hLbDFreY70W6h1WyXovKYg9W+EI5yMRKWw
hIguYaVZZWXg8J6t7tzMFhlFehY0N+o/q7hmslEmJyH6iNSw56CK9um8dmCWnUpQ
VPhYvKzxQxbDGEcHLD5A1i+Z5qjoAr+fkMDyflITRj4B4FOe2dY=
=o6pE
-----END PGP SIGNATURE-----

--Apple-Mail=_FC03F969-28FF-4EED-A537-F3271E086ECA--
