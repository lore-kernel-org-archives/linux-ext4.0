From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: running mkfs.ext4 causes very high system load
Date: Thu, 22 Mar 2012 20:15:18 +0100
Message-ID: <20120322191518.GA2049@nik-comp.lan>
References: <20120322140547.GA10657@pcnci2.linuxbox.cz> <20120322153500.GE25897@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Cc: linux-ext4@vger.kernel.org,
	Radovan Mzik <radovan.mzik@linuxbox.cz>,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:37821 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030364Ab2CVTPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 15:15:25 -0400
Content-Disposition: inline
In-Reply-To: <20120322153500.GE25897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi Ted!

> Mke2fs generates a large number of writes, and with LVM, if you are
> writing a lot to an LV which uses physical disks shared by other LV's,
> ultimately you are going to run into disk contention.  It sounds like
> from your description that your system is pretty busy, and other
> applications are using the disks pretty heavily.
>=20
> The other potential thing that could be happening is that mke2fs is
> dirtying a lot of memory blocks when it writes to the disk, and so
> your system is thrashing due memory pressure.

You're pretty right! After applying Your patch (+ one more small
fix to build on centos5) and using -D parameter, mkfs really got slower,
bud didn't affect system load almost at all!

> If it is caused by memory pressure it may be that using direct I/O
> will help make mke2fs be more "polite" at the expensive of taking a bit l=
onger.
>=20
> Here are patches versus the latest e2fsprogs (1.42.1) that might be
> helpful.  After you apply them, run mke2fs with the -D option to force
> the use of direct I/O.  Let me know if it makes a difference for you.

so it really made the difference.=20

Thanks a lot!

with regards

nik


>=20
> Regards,
>=20
> 						 - Ted
>=20
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index a63ea18..b06371c 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -119,6 +119,8 @@ errcode_t ext2fs_initialize(const char *name, int fla=
gs,
>  	io_flags =3D IO_FLAG_RW;
>  	if (flags & EXT2_FLAG_EXCLUSIVE)
>  		io_flags |=3D IO_FLAG_EXCLUSIVE;
> +	if (flags & EXT2_FLAG_DIRECT_IO)
> +		io_flags |=3D IO_FLAG_DIRECT_IO;
>  	retval =3D manager->open(name, io_flags, &fs->io);
>  	if (retval)
>  		goto cleanup;
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 8e78249..9f1fa29 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -18,6 +18,9 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
>  .I block-size
>  ]
>  [
> +.B \-D
> +]
> +[
>  .B \-f
>  .I fragment-size
>  ]
> @@ -184,6 +187,11 @@ Check the device for bad blocks before creating the =
file system.  If
>  this option is specified twice, then a slower read-write
>  test is used instead of a fast read-only test.
>  .TP
> +.B \-D
> +Use direct I/O when writing to the disk.  This avoids mke2fs dirtying a
> +lot of buffer cache memory which may impact other applications running
> +on a busy server, at the expense of causing mke2fs to run much more slow=
ly.
> +.TP
>  .BI \-E " extended-options"
>  Set extended options for the filesystem.  Extended options are comma
>  separated, and may take an argument using the equals ('=3D') sign.  The
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 51435d2..b8ff19b 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -88,6 +88,7 @@ int	verbose;
>  int	quiet;
>  int	super_only;
>  int	discard =3D 1;	/* attempt to discard device before fs creation */
> +int	direct_io;
>  int	force;
>  int	noaction;
>  int	journal_size;
> @@ -1321,7 +1322,7 @@ profile_error:
>  	}
> =20
>  	while ((c =3D getopt (argc, argv,
> -		    "b:cg:i:jl:m:no:qr:s:t:vC:E:FG:I:J:KL:M:N:O:R:ST:U:V")) !=3D EOF) {
> +		    "b:cg:i:jl:m:no:qr:s:t:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) !=3D EOF)=
 {
>  		switch (c) {
>  		case 'b':
>  			blocksize =3D strtol(optarg, &tmp, 0);
> @@ -1354,6 +1355,9 @@ profile_error:
>  				exit(1);
>  			}
>  			break;
> +		case 'D':
> +			direct_io =3D 1;
> +			break;
>  		case 'g':
>  			fs_param.s_blocks_per_group =3D strtoul(optarg, &tmp, 0);
>  			if (*tmp) {
> @@ -2257,6 +2261,8 @@ int main (int argc, char *argv[])
>  	 * Initialize the superblock....
>  	 */
>  	flags =3D EXT2_FLAG_EXCLUSIVE;
> +	if (direct_io)
> +		flags |=3D EXT2_FLAG_DIRECT_IO;
>  	profile_get_boolean(profile, "options", "old_bitmaps", 0, 0,
>  			    &old_bitmaps);
>  	if (!old_bitmaps)
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9rekUACgkQ3xdJJrLygV6hPgCeJOLYZtyI+7TA3SWX1iFNyke4
SxgAn0DsHYsOB5PD0sEf1m8DBuLUagp5
=1egK
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
