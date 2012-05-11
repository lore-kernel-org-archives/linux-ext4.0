From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Fri, 11 May 2012 18:31:35 +0300
Message-ID: <4FAD30D7.3070208@panasas.com>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de> <20120511034945.GA15892@mobil.systemanalysen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ludwig Nussel <ludwig.nussel@suse.de>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Rob Landley <rob@landley.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, open list:
	EXT2 FILE SYSTEM <linux-ext4@vger.kernel.org>, ; open list:
	DOCUMENTATION <linux-doc@vger.kernel.org>, ;
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120511034945.GA15892@mobil.systemanalysen.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/11/2012 06:49 AM, Roland Eggner wrote:

> On 2012-05-10 Thu 16:42 +0200, Ludwig Nussel wrote:
>> =E2=80=A6
>> When using 'real' file systems on removable storage devices such as
>> hard disks or usb sticks people quickly face the problem that their
>> Linux users have different uids on different machines. Therefore one
>> cannot modify or even read files created on a different machine
>> without running chown as root or storing everything with mode 777.
>> Simple file systems such as vfat don't have that problem as they
>> don't store file ownership information and one can pass the uid
>> files should belong to as mount option.
>>
>> The following two patches (for 3.4.0-rc4) implement the uid (and
>> gid) mount option for ext2, ext3 and ext4 to make them actually
>> useful on removable media. If a file system is mounted with the uid
>> option all files appear to be owned by the specified uid. Only newly
>> created files actually end up with that uid as owner on disk though.
>> Ownership of existing files cannot be changed permanently if the uid
>> option was specified.
>>
>> Acked-by: Rob Landley <rob@landley.net>
>> Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
>> ---
>>  Documentation/filesystems/ext2.txt |    9 ++++++
>>  Documentation/filesystems/ext3.txt |    9 ++++++
>>  Documentation/filesystems/ext4.txt |    9 ++++++
>>  fs/ext2/ext2.h                     |    8 +++++
>>  fs/ext2/inode.c                    |   42 ++++++++++++++++++++-----=
-
>>  fs/ext2/super.c                    |   57 +++++++++++++++++++++++++=
++++++++++-
>>  fs/ext3/ext3.h                     |    8 +++++
>>  fs/ext3/inode.c                    |   50 ++++++++++++++++++++++---=
------
>>  fs/ext3/super.c                    |   57 +++++++++++++++++++++++++=
++++++++++-
>>  fs/ext4/ext4.h                     |    4 ++
>>  fs/ext4/inode.c                    |   50 ++++++++++++++++++++++---=
------
>>  fs/ext4/super.c                    |   49 +++++++++++++++++++++++++=
+++++-
>>  12 files changed, 311 insertions(+), 41 deletions(-)
>>
>> =E2=80=A6
>=20
>=20
> In short:
> .........
> Problem solving at its root is more efficient than at =E2=80=9Cend of=
 pipe=E2=80=9D.
>=20
>=20
>=20
> IMHO this is an example of =E2=80=9Cend of pipe=E2=80=9C thinking wit=
h following downsides:
> .....................................................................=
=2E.....
> *  Maintainers point of view:
>    *  Introduces new problems:  Breaking holes in the access restrict=
ions
>       provided by the Linux kernel at will of unprivileged users woul=
d render
>       the kernel unusable for reliable operation in multiuser environ=
ments.
>    *  Adds code complexity and risk of bugs.
>    *  Adds future maintainance load.
> *  Users point of view:
>    *  Editing /etc/fstab or using mount commands with options not in
>       /etc/fstab require root privileges anyway, at least on sane sys=
tems.
>    *  Adds usage complexity (new vs. old files, on disk vs. pretended=
 UIDs =E2=80=A6).
>    *  Adds risk of usage errors.
>=20
>=20
>=20
> IMHO the =E2=80=9Cright thing to do=E2=80=9D is to solve the problem =
at its root:
> .................................................................
> My habit is, whenever I use {group,user}add commands:
> *  In advance I create a list of all current and future users (user, =
GID, UID)
>    common to all systems that might exchange files.  The list is desi=
gned to
>    have =E2=80=9Cheadroom=E2=80=9D for future additions.
> *  I always consult this list and use options --gid $userGID --uid $u=
serUID to
>    {group,user}add commands.
> *  Exchanging files with an unforeseen system is an exception, which =
requires
>    root privileges anyway,
>=20
> Advantages:
> *  Decent migration of files to other systems via backups, external s=
torage =E2=80=A6
> *  No NEW wholes in the access restrictions provided by the Linux ker=
nel.
> *  No NEW kernel code possibly introducing bugs.
> *  No need to learn new mount options.
> *  No NEW risks of usage errors.
>=20
>=20
> Summary:
> ........
> *  If UIDs differ on machines FORESEEN for file exchange, this is an
>    administrator error, not a kernel deficit.
> *  File exchange with an UNFORESEEN system requires root privileges a=
nyway.
>=20
>=20


I agree with Ludwig completely!!! Thanks, good policy rules.

1. ext* are nothing special and are not a special domain of removable m=
edia.
   (If any vfat is dominant at that end)

2. What the hell does removable-media means? and how is it different th=
en
   something else? is ext* over iscsi removable? a soft-mount NFS, is i=
t
   removable?

Above sounds to me like a huge security breach, and actually a data-cor=
ruption.

In the NFS world I hang around, we constantly encounter multiple domain
uid/gid views, and it does not mean we blow a hole in POSIX security ru=
les.

The root that mounts this FS can just copy+chmod or just-chmod them.
Next we'll see auto-mounters use these flags and goodbye file-access-co=
ntrol.

There is some convenience you do not allow. a password-less root, and n=
o access
control at all is most convenient would you say?

I bet this code opens up an attack vector like crazy. Windows viruses w=
elcome.

No thanks
Boaz

>=20

> Thanks,
> Roland Eggner
