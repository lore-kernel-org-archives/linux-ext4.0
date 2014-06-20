From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2 V2] e2fsprogs: revise and extend chattr(1) and chattr usage()
Date: Fri, 20 Jun 2014 12:44:50 -0600
Message-ID: <F4AA1D31-C622-4BD1-961D-137D4B589EB0@dilger.ca>
References: <53A36F0E.6090105@redhat.com> <53A37129.2040409@redhat.com> <53A44679.4020001@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_DFEB77BB-C522-4F82-AF7E-9F49695AA886"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53425 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbaFTSon (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jun 2014 14:44:43 -0400
Received: by mail-pa0-f41.google.com with SMTP id fb1so3404588pad.14
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2014 11:44:42 -0700 (PDT)
In-Reply-To: <53A44679.4020001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DFEB77BB-C522-4F82-AF7E-9F49695AA886
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jun 20, 2014, at 8:34 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> The chattr(1) manpage and chattr usage() output were missing some =
flags.
>=20
> Add those, and make some other minor cosmetic fixes.
>=20
> (I've left out the 'B' (EXT2_COMPRBLK_FL) flag, because
> it's not actually used anywhere, and I can't figure out
> how it differs from 'c' (EXT2_COMPR_FL))
>=20
> Also, because the matrix of filesystems & flags is quite large,
> refer to filesystem-specific manpages for detailed discussion
> of flags supported by those filesystems, rather than trying to
> cover it all in this manpage.  I'll send those manpage
> updates to the appropriate lists a bit later.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> V2: Make the single-quotes non-backticky; get consistent in
> the other direction.
>=20
> diff --git a/misc/chattr.1.in b/misc/chattr.1.in
> index ce426e8..fd3b39b 100644
> --- a/misc/chattr.1.in
> +++ b/misc/chattr.1.in
> @@ -21,11 +21,11 @@ changes the file attributes on a Linux file =
system.
> .PP
> The format of a symbolic mode is +-=3D[aAcCdDeijsStTu].
> .PP
> -The operator `+' causes the selected attributes to be added to the
> -existing attributes of the files; `-' causes them to be removed; and
> -`=3D' causes them to be the only attributes that the files have.
> +The operator '+' causes the selected attributes to be added to the
> +existing attributes of the files; '-' causes them to be removed; and
> +'=3D' causes them to be the only attributes that the files have.
> .PP
> -The letters `aAcCdDeijsStTu' select the new attributes for the files:
> +The letters 'aAcCdDeijsStTu' select the new attributes for the files:
> append only (a),
> no atime updates (A),
> compressed (c),
> @@ -47,8 +47,17 @@ but not modified by chattr:
> compression error (E),
> huge file (h),
> indexed directory (I),
> +inline data (N),
> compression raw access (X),
> and compressed dirty file (Z).
> +.PP
> +Not all flags are supported or utilized by all filesystems; refer to
> +filesystem-specific man pages such as
> +.BR btrfs (5),=20
> +.BR ext4 (5),
> +and
> +.BR xfs (5)
> +for more filesystem-specific details.
> .SH OPTIONS
> .TP
> .B \-R
> @@ -63,7 +72,7 @@ Suppress most error messages.
> .BI \-v " version"
> Set the file's version/generation number.
> .SH ATTRIBUTES
> -A file with the `a' attribute set can only be open in append mode for =
writing.
> +A file with the 'a' attribute set can only be open in append mode for =
writing.
> Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> capability can set or clear this attribute.
> .PP
> @@ -71,7 +80,7 @@ When a file with the 'A' attribute set is accessed, =
its atime record is
> not modified.  This avoids a certain amount of disk I/O for laptop
> systems.
> .PP
> -A file with the `c' attribute set is automatically compressed on the =
disk
> +A file with the 'c' attribute set is automatically compressed on the =
disk
> by the kernel.  A read from this file returns uncompressed data.  A =
write to
> this file compresses data before storing them on the disk.  Note: =
please
> make sure to read the bugs and limitations section at the end of this
> @@ -86,13 +95,13 @@ be fully stable.  If the 'C' flag is set on a =
directory, it will have no
> effect on the directory, but new files created in that directory will
> the No_COW attribute.)
> .PP
> -A file with the `d' attribute set is not candidate for backup when =
the
> +A file with the 'd' attribute set is not candidate for backup when =
the
> .BR dump (8)
> program is run.
> .PP
> -When a directory with the `D' attribute set is modified,
> +When a directory with the 'D' attribute set is modified,
> the changes are written synchronously on the disk; this is equivalent =
to
> -the `dirsync' mount option applied to a subset of the files.
> +the 'dirsync' mount option applied to a subset of the files.
> .PP
> The 'e' attribute indicates that the file is using extents for mapping
> the blocks on disk.  It may not be removed using
> @@ -112,7 +121,7 @@ is (or at one time was) larger than 2TB.  It may =
not be set or reset using
> although it can be displayed by
> .BR lsattr (1).
> .PP
> -A file with the `i' attribute cannot be modified: it cannot be =
deleted or
> +A file with the 'i' attribute cannot be modified: it cannot be =
deleted or
> renamed, no link can be created to this file and no data can be =
written
> to the file.  Only the superuser or a process possessing the
> CAP_LINUX_IMMUTABLE capability can set or clear this attribute.
> @@ -123,7 +132,7 @@ is being indexed using hashed trees.  It may not =
be set or reset using
> although it can be displayed by
> .BR lsattr (1).
> .PP
> -A file with the `j' attribute has all of its data written to the ext3
> +A file with the 'j' attribute has all of its data written to the ext3
> or ext4 journal before being written to the file itself, if the =
filesystem
> is mounted with the "data=3Dordered" or "data=3Dwriteback" options.  =
When the
> filesystem is mounted with the "data=3Djournal" option all file data
> @@ -131,13 +140,19 @@ is already journalled and this attribute has no =
effect.  Only
> the superuser or a process possessing the CAP_SYS_RESOURCE
> capability can set or clear this attribute.
> .PP
> -When a file with the `s' attribute set is deleted, its blocks are =
zeroed
> +A file with the 'N' attribute set indicates that the file has data=20
> +stored inline, within the inode itself. It may not be set or reset =
using
> +.BR chattr (1),
> +although it can be displayed by
> +.BR lsattr (1).
> +.PP
> +When a file with the 's' attribute set is deleted, its blocks are =
zeroed
> and written back to the disk.  Note: please make sure to read the bugs
> and limitations section at the end of this document.
> .PP
> -When a file with the `S' attribute set is modified,
> +When a file with the 'S' attribute set is modified,
> the changes are written synchronously on the disk; this is equivalent =
to
> -the `sync' mount option applied to a subset of the files.
> +the 'sync' mount option applied to a subset of the files.
> .PP
> A file with the 't' attribute will not have a partial block fragment =
at
> the end of the file merged with other files (for those filesystems =
which
> @@ -156,13 +171,13 @@ and /home/mary are placed into separate block =
groups.  For directories
> where this attribute is not set, the Orlov block allocator will try to
> group subdirectories closer together where possible.
> .PP
> -When a file with the `u' attribute set is deleted, its contents are
> +When a file with the 'u' attribute set is deleted, its contents are
> saved.  This allows the user to ask for its undeletion.  Note: please
> make sure to read the bugs and limitations section at the end of this
> document.
> .PP
> The 'X' attribute is used by the experimental compression patches to
> -indicate that a raw contents of a compressed file can be accessed
> +indicate that the raw contents of a compressed file can be accessed
> directly.  It currently may not be set or reset using
> .BR chattr (1),
> although it can be displayed by
> @@ -179,16 +194,19 @@ although it can be displayed by
> was written by Remy Card <Remy.Card@linux.org>.  It is currently being
> maintained by Theodore Ts'o <tytso@alum.mit.edu>.
> .SH BUGS AND LIMITATIONS
> -The `c', 's',  and `u' attributes are not honored
> +The 'c', 's',  and 'u' attributes are not honored
> by the ext2, ext3, and ext4 filesystems as implemented in the current
> mainline Linux kernels.
> .PP
> -The `j' option is only useful if the filesystem is mounted as ext3 or =
ext4.
> +The 'j' option is only useful if the filesystem is mounted as ext3 or =
ext4.
> .PP
> -The `D' option is only useful on Linux kernel 2.5.19 and later.
> +The 'D' option is only useful on Linux kernel 2.5.19 and later.
> .SH AVAILABILITY
> .B chattr
> is part of the e2fsprogs package and is available from
> http://e2fsprogs.sourceforge.net.
> .SH SEE ALSO
> -.BR lsattr (1)
> +.BR lsattr (1),
> +.BR btrfs (5),
> +.BR ext4 (5),
> +.BR xfs (5).
> diff --git a/misc/chattr.c b/misc/chattr.c
> index d5a6a61..f130108 100644
> --- a/misc/chattr.c
> +++ b/misc/chattr.c
> @@ -83,7 +83,7 @@ static unsigned long sf;
> static void usage(void)
> {
> 	fprintf(stderr,
> -		_("Usage: %s [-RVf] [-+=3DaAcCdDeijsSu] [-v version] =
files...\n"),
> +		_("Usage: %s [-RVf] [-+=3DaAcCdDeijsStTu] [-v version] =
files...\n"),
> 		program_name);
> 	exit(1);
> }
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_DFEB77BB-C522-4F82-AF7E-9F49695AA886
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU6SBInKl2rkXzB/gAQLYcxAAutHYryHrF9xG9beXUWOcg3wXX1fw/VF9
IoKoaH8vhCt+PESEhfYd6Mhyo/U8qa37RtrPO2/DYlQOBO8Ax5kZBteu28HNCqDu
A4zS4k8BnLaVWvU17bf25VumZIxAvmN45stvfxZq8r7/BAdh80eFhF4OEzF1BBDF
MFXtJdjPbNadK0emtj9hW9N8pqDNHHOJLszqlDIY9d3zN0VpEd/cZAq7apiVvwWK
KydSiw35rmmQG272RrXtbewWyAkVNJ0+baTBk/tByMg7mpYpr5jw9O/O5GXcIzqo
XHxez31HOzxxqQs8muRHmAkt5NATKFDhx331VocIS3jMYVGjQSXgqQFSYI6pALsd
0z3eh/AUrVVIyq4eDTVgb1BbNXrZjscJUMWcmtDmw6AvxGgh8qxCIF136ueD9STA
sFeliuwkajOCuVffZiavmP5ZYLYeMwurfP6lSJWMoQhWa9EsnImp06eYWJA1JuVD
qtmfqt/lwXGLxgns05m+dhUVgsp1Oscua05RUD+k6ASOmvhwcQhCbKcPKS3DusHV
iBmSH0PAzS6BpVmgnhYD5ZTZXnlHAJKbgtvZWm2+xLpDwQ5jayx71zbARUIspp64
vELpjn60fKW6cPyDs8t3Qa0cQMFPGahUtNSTPaeJ64Y9dOv5xrX0TYreYPbtiMId
FzmOcBGXUwM=
=n03W
-----END PGP SIGNATURE-----

--Apple-Mail=_DFEB77BB-C522-4F82-AF7E-9F49695AA886--
