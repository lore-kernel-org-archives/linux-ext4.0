From: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Fri, 11 May 2012 05:49:45 +0200
Message-ID: <20120511034945.GA15892@mobil.systemanalysen.net>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Rob Landley <rob@landley.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-05-10 Thu 16:42 +0200, Ludwig Nussel wrote:
> =E2=80=A6
> When using 'real' file systems on removable storage devices such as
> hard disks or usb sticks people quickly face the problem that their
> Linux users have different uids on different machines. Therefore one
> cannot modify or even read files created on a different machine
> without running chown as root or storing everything with mode 777.
> Simple file systems such as vfat don't have that problem as they
> don't store file ownership information and one can pass the uid
> files should belong to as mount option.
>=20
> The following two patches (for 3.4.0-rc4) implement the uid (and
> gid) mount option for ext2, ext3 and ext4 to make them actually
> useful on removable media. If a file system is mounted with the uid
> option all files appear to be owned by the specified uid. Only newly
> created files actually end up with that uid as owner on disk though.
> Ownership of existing files cannot be changed permanently if the uid
> option was specified.
>=20
> Acked-by: Rob Landley <rob@landley.net>
> Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
> ---
>  Documentation/filesystems/ext2.txt |    9 ++++++
>  Documentation/filesystems/ext3.txt |    9 ++++++
>  Documentation/filesystems/ext4.txt |    9 ++++++
>  fs/ext2/ext2.h                     |    8 +++++
>  fs/ext2/inode.c                    |   42 ++++++++++++++++++++------
>  fs/ext2/super.c                    |   57 ++++++++++++++++++++++++++++++=
+++++-
>  fs/ext3/ext3.h                     |    8 +++++
>  fs/ext3/inode.c                    |   50 ++++++++++++++++++++++---------
>  fs/ext3/super.c                    |   57 ++++++++++++++++++++++++++++++=
+++++-
>  fs/ext4/ext4.h                     |    4 ++
>  fs/ext4/inode.c                    |   50 ++++++++++++++++++++++---------
>  fs/ext4/super.c                    |   49 ++++++++++++++++++++++++++++++-
>  12 files changed, 311 insertions(+), 41 deletions(-)
>
> =E2=80=A6


In short:
=2E........
Problem solving at its root is more efficient than at =E2=80=9Cend of pipe=
=E2=80=9D.



IMHO this is an example of =E2=80=9Cend of pipe=E2=80=9C thinking with foll=
owing downsides:
=2E........................................................................=
=2E.
*  Maintainers point of view:
   *  Introduces new problems:  Breaking holes in the access restrictions
      provided by the Linux kernel at will of unprivileged users would rend=
er
      the kernel unusable for reliable operation in multiuser environments.
   *  Adds code complexity and risk of bugs.
   *  Adds future maintainance load.
*  Users point of view:
   *  Editing /etc/fstab or using mount commands with options not in
      /etc/fstab require root privileges anyway, at least on sane systems.
   *  Adds usage complexity (new vs. old files, on disk vs. pretended UIDs =
=E2=80=A6).
   *  Adds risk of usage errors.



IMHO the =E2=80=9Cright thing to do=E2=80=9D is to solve the problem at its=
 root:
=2E................................................................
My habit is, whenever I use {group,user}add commands:
*  In advance I create a list of all current and future users (user, GID, U=
ID)
   common to all systems that might exchange files.  The list is designed to
   have =E2=80=9Cheadroom=E2=80=9D for future additions.
*  I always consult this list and use options --gid $userGID --uid $userUID=
 to
   {group,user}add commands.
*  Exchanging files with an unforeseen system is an exception, which requir=
es
   root privileges anyway,

Advantages:
*  Decent migration of files to other systems via backups, external storage=
 =E2=80=A6
*  No NEW wholes in the access restrictions provided by the Linux kernel.
*  No NEW kernel code possibly introducing bugs.
*  No need to learn new mount options.
*  No NEW risks of usage errors.


Summary:
=2E.......
*  If UIDs differ on machines FORESEEN for file exchange, this is an
   administrator error, not a kernel deficit.
*  File exchange with an UNFORESEEN system requires root privileges anyway.



Thanks,
Roland Eggner

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk+sjFkACgkQdN/hKfT7G/LyuACfZ/l08Jfi/eMPukBzOc8QKHjR
mUoAn3h+N96pE+3+gK5NiHBnpc5jbQZc
=suRZ
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
