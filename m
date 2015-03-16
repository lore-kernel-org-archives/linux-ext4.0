From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC v2 0/6] ext4: yet another project quota
Date: Mon, 16 Mar 2015 17:52:28 +0100
Message-ID: <20150316165228.GT4934@quack.suse.cz>
References: <20150310171133.23081.49616.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213AbbCPQwe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2015 12:52:34 -0400
Content-Disposition: inline
In-Reply-To: <20150310171133.23081.49616.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 10-03-15 20:22:04, Konstantin Khlebnikov wrote:
> Projects quota allows to enforce disk quota for several subtrees or e=
ven
> individual files on the filesystem. Each inode is marked with project=
-id
> (independently from uid and gid) and accounted into corresponding pro=
ject
> quota. New files inherits project id from directory where they are cr=
eated.
>=20
> This is must-have feature for deploying lightweight containers.
> Also project quota can tell size of subtree without doing recursive '=
du'.
>=20
> This patchset adds project id and quota into ext4.
>=20
> This time I've prepared patches also for e2fsprogs and quota-tools.
>=20
> All patches are available at github:
> https://github.com/koct9i/linux --branch project
> https://github.com/koct9i/e2fsprogs --branch project
> https://github.com/koct9i/quota-tools --branch project
>
> Porposed behavior is similar to project quota in XFS:
>=20
> * all inode are marked with project id
> * new files inherits project id from parent directory
> * project quota accounts inodes and enforces limits
> * cross-project link and rename operations are restricted
  Thanks for the patches and sorry for taking a long time to look into
them. I like your patches and they looks mostly fine to me but can we
*please* start with making things completely compatible with how XFS wo=
rks?
I understand that may seem broken / not useful for your usecase but
consistency among filesystems is really important.=20

I was talking with Dave Chinner last week and we agreed that the direct=
ion
you are changing things makes sense but getting things compatible with =
how
they were for 15 years in XFS is an important first step (because there=
 may
be people with other usecases depending on the old behavior and they wo=
uld
get confused by ext4 behaving differently). After we have compatible co=
de
in, we can add your fs.protected_projects thing on top of that (and als=
o
support it in XFS to stay compatible).

> Differences:
>=20
> There is no flag similar to XFS_XFLAG_PROJINHERIT (which allows to di=
sable
> project id inheritance), instead of that project which userspace sees=
 as '0'
> (in nested user-name space that might be actually non-zero project) a=
cts as
> default project where restrictions for link/rename are ignored.
> (also see below, in "why new ioctl" part)
>=20
> This implementation adds shortcut for moving files from one project i=
nto
> another: non-directory inodes with n_link =3D=3D 1 are transferred wi=
thout
> copying (XFS in this case returns -EXDEV and userspace have to copy f=
ile).
>=20
> In XFS file owner (or process with CAP_FOWNER) can set set any projec=
t id,
> XFS permits changing project id only from init user-namespace.
>=20
> This patchset adds sysctl fs.protected_projects. By default it's 0 an=
d project
> id acts as XFS project. Setting it to 1 makes chaning project id priv=
iliged
> operation which requires CAP_SYS_RESOURCE in current user-namespace, =
changing
> project id mapping for nested user-namespace also requires that capab=
ility.
> Thus there are two levels of control: project id mapping in user-ns d=
efines set
> of permitted projects and capability protects operations within this =
set.
>=20
> I see no problems with supporting all this in XFS, all difference in =
interface.
>=20
> Ext4 layout
> -----------
>=20
> Project id introduce ro-compatible feature 'project'.
>=20
> Inode project id is stored in place of obsolete field 'i_faddr' (that=
 trick was
> suggested by Darrick J. Wong in previous discussions of project quota=
).
> Linux never used that field and present fsck checks that it contains =
zero.
>=20
> Quota information is stored in special inode =E2=84=9611 (by default =
only 10 inodes are
> reserved for special usage, I've add option to resize2fs to reserve m=
ore).
> (see e2fsprogs patches for details) For symmetry with other quotas in=
ode number
> is stored in superblock.
>=20
> Project quota supports only modern 'hidden' journaled mode.
>=20
> Interface
> ---------
>=20
> Interface for changing limits / query current usage is common vfs quo=
tactl()
> where quotatype =3D PRJQUOTA =3D 2. User can query current state of a=
ny project
> mapped into user-ns, changing of limits requires CAP_SYS_ADMIN in ini=
t user-ns.
>=20
> Two new ioctls for getting / changing inode project id:
> int ioctl(fd, FS_IOC_GETPROJECT, unsigned *project);
> int ioctl(fd, FS_IOC_SETPROJECT, unsigned *project);
>=20
> They acts as interface for super-block methods get_project / set_proj=
ect
> Generic code checks permissions, does project id translation in user-=
namespace
> mapping, grabs write-access to the filesystem, locks i_mutex for set =
opetaion.
> Filesystem method only updates inode and transfers project quota.
>=20
> No new mount options added. Disk usage tracking is enabled at mount.
> Limits are enabeld later by "quotaon".
>=20
> (BTW why journalled quota doesn't enable limits right at the time of =
mounting?)
  Well, mostly historical reasons :) The biggest probably was that to
properly initialize quotas (or fix them if quota file gets corrupted) y=
ou
have to still run quotacheck and for that kernel mustn't touch the file=
s.
At the time when I was writing journaled quotas I didn't feel like addi=
ng
quotacheck support into e2fsck... We eventually did that anyway for sup=
port
of quota in system files but how we did that was actually based on the
experience I had from the journaled quota lesson ;).

> Why new ioctls?
> ---------------
>=20
> XFS has it's own interface for that: XFS_IOC_FSGETXATTR / XFS_IOC_FSS=
ETXATTR.
> But it has several flaws and doesn't fit for a role of generic interf=
ace.
>=20
> It contains a lot of xfs-specific flags and racy by design: set opera=
tion
> commits all fields at once thus it's used in sequence get-change-set =
without
> any lock, Concurrent updates from user space will collide.
  Sure but that's the case for generic GETFLAGS / SETFLAGS interface as
well.

> Also xfs has flag XFS_XFLAG_PROJINHERIT which tells should new files =
inherit
> project id from parent directory or not. This flag is barely useful a=
nd only
> makes everything complicated. Even tools in xfsprogs don't use it: th=
ey always
> set it together with project id and clears when set project id back t=
o zero.
  I think this is about balance - adding the support for the PROJINHERI=
T flag
costs us close to nothing and we get a compatibility with XFS. So even =
though
the usefulness of that flag is doubtful, I think the additional
compatibility is worth it.

> And the main reason: this compatibility gives nothing. The only user =
of xfs
> ioctl which I've found is the xfsprogs. And these tools check filesys=
tem name
> and don't work anywhere except 'xfs'.
  The fact that you didn't find any other user doesn't mean there isn't
any. And historically if we though "nobody could be relying on this", w=
e
were sometimes proven wrong - a few years later when it was *much* more
painful to make things compatible.

Here we speak about new feature for the filesystem so compatibility
requirements aren't that strong but still I find the case that the same
ioctl will just work on ext4 as it does on xfs more appealing than crea=
ting
a new simpler generic ioctl. That way userspace doesn't have to care on
which filesystem it is working or whether the current kernel already
supports the new ioctl for XFS. So please use the XFS interface is Li X=
i
does in his patches.

								Honza

> Links
> -----
>=20
> [1] 2014-12-09  ext4: add project quota support by Li Xi
> http://marc.info/?l=3Dlinux-fsdevel&m=3D141810265603565&w=3D2
>=20
> [2] 2014-01-28  A draft for making ext4 support project quota by Zhen=
g Liu
> http://marc.info/?l=3Dlinux-ext4&m=3D139089109605795&w=3D2
>=20
> [3] 2012-07-09  introduce extended inode owner identifier v10 by Dmit=
ry Monakhov
> http://thread.gmane.org/gmane.linux.file-systems/65752
>=20
> [4] 2010-02-08  Introduce subtree quota support by Dmitry Monakhov
> http://thread.gmane.org/gmane.comp.file-systems.ext4/17530
>=20
>=20
> ---
>=20
> Konstantin Khlebnikov (6):
>       fs: vfs ioctls for managing project id
>       fs: protected project id
>       quota: generic project quota
>       ext4: support project id and project quota
>       ext4: add shortcut for moving files across projects
>       ext4: mangle statfs results accourding to project quota usage a=
nd limits
>=20
>=20
>  Documentation/filesystems/Locking |    4 +
>  Documentation/filesystems/vfs.txt |    8 +++
>  Documentation/sysctl/fs.txt       |   16 ++++++
>  fs/compat_ioctl.c                 |    2 +
>  fs/ext4/ext4.h                    |   15 ++++-
>  fs/ext4/ialloc.c                  |    3 +
>  fs/ext4/inode.c                   |   15 +++++
>  fs/ext4/namei.c                   |  102 +++++++++++++++++++++++++++=
+++++++++-
>  fs/ext4/super.c                   |   61 ++++++++++++++++++++--
>  fs/ioctl.c                        |   62 ++++++++++++++++++++++
>  fs/quota/dquot.c                  |   96 +++++++++++++++++++++++++++=
++++++--
>  fs/quota/quota.c                  |    8 ++-
>  fs/quota/quotaio_v2.h             |    6 +-
>  include/linux/fs.h                |    3 +
>  include/linux/quota.h             |    1=20
>  include/linux/quotaops.h          |   16 ++++++
>  include/uapi/linux/capability.h   |    1=20
>  include/uapi/linux/fs.h           |    3 +
>  include/uapi/linux/quota.h        |    6 +-
>  kernel/sysctl.c                   |    9 +++
>  kernel/user_namespace.c           |    4 +
>  21 files changed, 416 insertions(+), 25 deletions(-)
>=20
> --
> Signature
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
