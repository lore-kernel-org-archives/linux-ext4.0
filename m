From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2 V2] e2fsprogs: reorder flags in chattr(1)
Date: Fri, 20 Jun 2014 12:45:40 -0600
Message-ID: <001D1C40-4106-4331-81A2-C12D97851AC0@dilger.ca>
References: <53A36F0E.6090105@redhat.com> <53A36F9D.3010803@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_FE35D305-8776-442A-9D41-B24AC46B5E37"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59774 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbaFTSpc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jun 2014 14:45:32 -0400
Received: by mail-pd0-f176.google.com with SMTP id ft15so3261865pdb.35
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2014 11:45:31 -0700 (PDT)
In-Reply-To: <53A36F9D.3010803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FE35D305-8776-442A-9D41-B24AC46B5E37
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jun 19, 2014, at 5:17 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> The flags described in chattr usage() and the chattr(1) manpage
> were in semi-random order, which makes it hard to ascertain
> which flags might be missing or undocumented, and to locate
> flags within the manpage.
>=20
> Re-order the list of flags in alphanumeric order, and do
> the same for the flag descriptions in the body of the manpage.
>=20
> There should be no content changes here, just reordering
> for consistency.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> V2: remove duplicate line in usage()!
> (why do I only spot these things immediately after I hit send?)
>=20
> diff --git a/misc/chattr.1.in b/misc/chattr.1.in
> index 2a3640c..ce426e8 100644
> --- a/misc/chattr.1.in
> +++ b/misc/chattr.1.in
> @@ -19,24 +19,36 @@ chattr \- change file attributes on a Linux file =
system
> .B chattr
> changes the file attributes on a Linux file system.
> .PP
> -The format of a symbolic mode is +-=3D[acdeijstuACDST].
> +The format of a symbolic mode is +-=3D[aAcCdDeijsStTu].
> .PP
> The operator `+' causes the selected attributes to be added to the
> existing attributes of the files; `-' causes them to be removed; and
> `=3D' causes them to be the only attributes that the files have.
> .PP
> -The letters `acdeijstuACDST' select the new attributes for the files:
> -append only (a), compressed (c), no dump (d), extent format (e), =
immutable (i),
> -data journalling (j), secure deletion (s), no tail-merging (t),
> -undeletable (u), no atime updates (A), no copy on write (C),
> -synchronous directory updates (D), synchronous updates (S),
> -and top of directory hierarchy (T).
> +The letters `aAcCdDeijsStTu' select the new attributes for the files:
> +append only (a),
> +no atime updates (A),
> +compressed (c),
> +no copy on write (C),
> +no dump (d),
> +synchronous directory updates (D),
> +extent format (e),
> +immutable (i),
> +data journalling (j),
> +secure deletion (s),
> +synchronous updates (S),
> +no tail-merging (t),
> +top of directory hierarchy (T),
> +and undeletable (u).
> .PP
> The following attributes are read-only, and may be listed by
> .BR lsattr (1)
> -but not modified by chattr: huge file (h), compression error (E),
> -indexed directory (I), compression raw access (X), and compressed =
dirty
> -file (Z).
> +but not modified by chattr:
> +compression error (E),
> +huge file (h),
> +indexed directory (I),
> +compression raw access (X),
> +and compressed dirty file (Z).
> .SH OPTIONS
> .TP
> .B \-R
> @@ -51,14 +63,14 @@ Suppress most error messages.
> .BI \-v " version"
> Set the file's version/generation number.
> .SH ATTRIBUTES
> -When a file with the 'A' attribute set is accessed, its atime record =
is
> -not modified.  This avoids a certain amount of disk I/O for laptop
> -systems.
> -.PP
> A file with the `a' attribute set can only be open in append mode for =
writing.
> Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> capability can set or clear this attribute.
> .PP
> +When a file with the 'A' attribute set is accessed, its atime record =
is
> +not modified.  This avoids a certain amount of disk I/O for laptop
> +systems.
> +.PP
> A file with the `c' attribute set is automatically compressed on the =
disk
> by the kernel.  A read from this file returns uncompressed data.  A =
write to
> this file compresses data before storing them on the disk.  Note: =
please
> @@ -74,27 +86,21 @@ be fully stable.  If the 'C' flag is set on a =
directory, it will have no
> effect on the directory, but new files created in that directory will
> the No_COW attribute.)
> .PP
> -When a directory with the `D' attribute set is modified,
> -the changes are written synchronously on the disk; this is equivalent =
to
> -the `dirsync' mount option applied to a subset of the files.
> -.PP
> A file with the `d' attribute set is not candidate for backup when the
> .BR dump (8)
> program is run.
> .PP
> -The 'E' attribute is used by the experimental compression patches to
> -indicate that a compressed file has a compression error.  It may not =
be
> -set or reset using
> -.BR chattr (1),
> -although it can be displayed by
> -.BR lsattr (1).
> +When a directory with the `D' attribute set is modified,
> +the changes are written synchronously on the disk; this is equivalent =
to
> +the `dirsync' mount option applied to a subset of the files.
> .PP
> The 'e' attribute indicates that the file is using extents for mapping
> the blocks on disk.  It may not be removed using
> .BR chattr (1).
> .PP
> -The 'I' attribute is used by the htree code to indicate that a =
directory
> -is being indexed using hashed trees.  It may not be set or reset =
using
> +The 'E' attribute is used by the experimental compression patches to
> +indicate that a compressed file has a compression error.  It may not =
be
> +set or reset using
> .BR chattr (1),
> although it can be displayed by
> .BR lsattr (1).
> @@ -111,6 +117,12 @@ renamed, no link can be created to this file and =
no data can be written
> to the file.  Only the superuser or a process possessing the
> CAP_LINUX_IMMUTABLE capability can set or clear this attribute.
> .PP
> +The 'I' attribute is used by the htree code to indicate that a =
directory
> +is being indexed using hashed trees.  It may not be set or reset =
using
> +.BR chattr (1),
> +although it can be displayed by
> +.BR lsattr (1).
> +.PP
> A file with the `j' attribute has all of its data written to the ext3
> or ext4 journal before being written to the file itself, if the =
filesystem
> is mounted with the "data=3Dordered" or "data=3Dwriteback" options.  =
When the
> @@ -127,6 +139,13 @@ When a file with the `S' attribute set is =
modified,
> the changes are written synchronously on the disk; this is equivalent =
to
> the `sync' mount option applied to a subset of the files.
> .PP
> +A file with the 't' attribute will not have a partial block fragment =
at
> +the end of the file merged with other files (for those filesystems =
which
> +support tail-merging).  This is necessary for applications such as =
LILO
> +which read the filesystem directly, and which don't understand =
tail-merged
> +files.  Note: As of this writing, the ext2 or ext3 filesystems do not
> +(yet, except in very experimental patches) support tail-merging.
> +.PP
> A directory with the 'T' attribute will be deemed to be the top of
> directory hierarchies for the purposes of the Orlov block allocator.
> This is a hint to the block allocator used by ext3 and ext4 that the
> @@ -137,13 +156,6 @@ and /home/mary are placed into separate block =
groups.  For directories
> where this attribute is not set, the Orlov block allocator will try to
> group subdirectories closer together where possible.
> .PP
> -A file with the 't' attribute will not have a partial block fragment =
at
> -the end of the file merged with other files (for those filesystems =
which
> -support tail-merging).  This is necessary for applications such as =
LILO
> -which read the filesystem directly, and which don't understand =
tail-merged
> -files.  Note: As of this writing, the ext2 or ext3 filesystems do not
> -(yet, except in very experimental patches) support tail-merging.
> -.PP
> When a file with the `u' attribute set is deleted, its contents are
> saved.  This allows the user to ask for its undeletion.  Note: please
> make sure to read the bugs and limitations section at the end of this
> diff --git a/misc/chattr.c b/misc/chattr.c
> index 39a6016..d5a6a61 100644
> --- a/misc/chattr.c
> +++ b/misc/chattr.c
> @@ -83,7 +83,7 @@ static unsigned long sf;
> static void usage(void)
> {
> 	fprintf(stderr,
> -		_("Usage: %s [-RVf] [-+=3DAaCcDdeijsSu] [-v version] =
files...\n"),
> +		_("Usage: %s [-RVf] [-+=3DaAcCdDeijsSu] [-v version] =
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






--Apple-Mail=_FE35D305-8776-442A-9D41-B24AC46B5E37
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU6SBVHKl2rkXzB/gAQLDkxAAq8yQQcAoLUuuJ5Qi2RcKz63IPfk8fEWx
mi9CHedJSQU8dS4QwebHPweKkGjNaMOZXjFUNu8kEv/JoyeltdAyNcRcGlBj4m3G
wbNtLJCLwwz8j2UoBmsL78UShFaKlimG3f77xyk/MrbzdsMtsN15JSHPTRu0070j
dMRJeMc5aVZ/PThDFaUcil7efojbVkqm4jWQIvmEVt8YVwTJJ1taFuA6Qc6fkp0A
y1I6SspW8Fl+azahXVNUtbX+kfMbrKCWcAi+QOvABa4cLi4MJ8veYXk8NDJtkhpa
6v6S/4Yo0FHja1ZizcyEVpQT+KOxriKElVfQKxDwbVU4c+QFzwfUCft63ctvluMN
jFNVtaDkhljAt4by7bjfCi2l0l9O6zsFFpA9n0FjSIiyNzFwcL+V8uAFYPXeTIRV
HnSQ0/yIw07b6benKgD8Zklr6yejfBoLsd7J7Eq4pYPsVZG0JUbPdr1qqpK9zYLT
fgr71xEGU5XP5XVQraW/cKXltn869jZ+fIi8j4b3XYVfle5YBleVMtLdtC34GdY3
1fjML4OhTHhbkUvfxJKrocIyIYBKcuYQXCXZlixux5vhAZm5AZoEIqT3s2LKAC1g
qcO3OL2a9tVI6idHVpBlY7u3lV6zMzNs/ns/COmId45NHSDFei6widf0IvY2GHMa
h75WEElBpOo=
=F16b
-----END PGP SIGNATURE-----

--Apple-Mail=_FE35D305-8776-442A-9D41-B24AC46B5E37--
