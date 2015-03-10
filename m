From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v2 0/6] ext4: yet another project quota
Date: Tue, 10 Mar 2015 20:22:04 +0300
Message-ID: <20150310171133.23081.49616.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>
To: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:36375 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbbCJRWL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2015 13:22:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Projects quota allows to enforce disk quota for several subtrees or eve=
n
individual files on the filesystem. Each inode is marked with project-i=
d
(independently from uid and gid) and accounted into corresponding proje=
ct
quota. New files inherits project id from directory where they are crea=
ted.

This is must-have feature for deploying lightweight containers.
Also project quota can tell size of subtree without doing recursive 'du=
'.

This patchset adds project id and quota into ext4.

This time I've prepared patches also for e2fsprogs and quota-tools.

All patches are available at github:
https://github.com/koct9i/linux --branch project
https://github.com/koct9i/e2fsprogs --branch project
https://github.com/koct9i/quota-tools --branch project

---

Porposed behavior is similar to project quota in XFS:

* all inode are marked with project id
* new files inherits project id from parent directory
* project quota accounts inodes and enforces limits
* cross-project link and rename operations are restricted

Differences:

There is no flag similar to XFS_XFLAG_PROJINHERIT (which allows to disa=
ble
project id inheritance), instead of that project which userspace sees a=
s '0'
(in nested user-name space that might be actually non-zero project) act=
s as
default project where restrictions for link/rename are ignored.
(also see below, in "why new ioctl" part)

This implementation adds shortcut for moving files from one project int=
o
another: non-directory inodes with n_link =3D=3D 1 are transferred with=
out
copying (XFS in this case returns -EXDEV and userspace have to copy fil=
e).

In XFS file owner (or process with CAP_FOWNER) can set set any project =
id,
XFS permits changing project id only from init user-namespace.

This patchset adds sysctl fs.protected_projects. By default it's 0 and =
project
id acts as XFS project. Setting it to 1 makes chaning project id privil=
iged
operation which requires CAP_SYS_RESOURCE in current user-namespace, ch=
anging
project id mapping for nested user-namespace also requires that capabil=
ity.
Thus there are two levels of control: project id mapping in user-ns def=
ines set
of permitted projects and capability protects operations within this se=
t.

I see no problems with supporting all this in XFS, all difference in in=
terface.

Ext4 layout
-----------

Project id introduce ro-compatible feature 'project'.

Inode project id is stored in place of obsolete field 'i_faddr' (that t=
rick was
suggested by Darrick J. Wong in previous discussions of project quota).
Linux never used that field and present fsck checks that it contains ze=
ro.

Quota information is stored in special inode =E2=84=9611 (by default on=
ly 10 inodes are
reserved for special usage, I've add option to resize2fs to reserve mor=
e).
(see e2fsprogs patches for details) For symmetry with other quotas inod=
e number
is stored in superblock.

Project quota supports only modern 'hidden' journaled mode.

Interface
---------

Interface for changing limits / query current usage is common vfs quota=
ctl()
where quotatype =3D PRJQUOTA =3D 2. User can query current state of any=
 project
mapped into user-ns, changing of limits requires CAP_SYS_ADMIN in init =
user-ns.

Two new ioctls for getting / changing inode project id:
int ioctl(fd, FS_IOC_GETPROJECT, unsigned *project);
int ioctl(fd, FS_IOC_SETPROJECT, unsigned *project);

They acts as interface for super-block methods get_project / set_projec=
t
Generic code checks permissions, does project id translation in user-na=
mespace
mapping, grabs write-access to the filesystem, locks i_mutex for set op=
etaion.
=46ilesystem method only updates inode and transfers project quota.

No new mount options added. Disk usage tracking is enabled at mount.
Limits are enabeld later by "quotaon".

(BTW why journalled quota doesn't enable limits right at the time of mo=
unting?)

Why new ioctls?
---------------

XFS has it's own interface for that: XFS_IOC_FSGETXATTR / XFS_IOC_FSSET=
XATTR.
But it has several flaws and doesn't fit for a role of generic interfac=
e.

It contains a lot of xfs-specific flags and racy by design: set operati=
on
commits all fields at once thus it's used in sequence get-change-set wi=
thout
any lock, Concurrent updates from user space will collide.

Also xfs has flag XFS_XFLAG_PROJINHERIT which tells should new files in=
herit
project id from parent directory or not. This flag is barely useful and=
 only
makes everything complicated. Even tools in xfsprogs don't use it: they=
 always
set it together with project id and clears when set project id back to =
zero.

And the main reason: this compatibility gives nothing. The only user of=
 xfs
ioctl which I've found is the xfsprogs. And these tools check filesyste=
m name
and don't work anywhere except 'xfs'.

Links
-----

[1] 2014-12-09  ext4: add project quota support by Li Xi
http://marc.info/?l=3Dlinux-fsdevel&m=3D141810265603565&w=3D2

[2] 2014-01-28  A draft for making ext4 support project quota by Zheng =
Liu
http://marc.info/?l=3Dlinux-ext4&m=3D139089109605795&w=3D2

[3] 2012-07-09  introduce extended inode owner identifier v10 by Dmitry=
 Monakhov
http://thread.gmane.org/gmane.linux.file-systems/65752

[4] 2010-02-08  Introduce subtree quota support by Dmitry Monakhov
http://thread.gmane.org/gmane.comp.file-systems.ext4/17530


---

Konstantin Khlebnikov (6):
      fs: vfs ioctls for managing project id
      fs: protected project id
      quota: generic project quota
      ext4: support project id and project quota
      ext4: add shortcut for moving files across projects
      ext4: mangle statfs results accourding to project quota usage and=
 limits


 Documentation/filesystems/Locking |    4 +
 Documentation/filesystems/vfs.txt |    8 +++
 Documentation/sysctl/fs.txt       |   16 ++++++
 fs/compat_ioctl.c                 |    2 +
 fs/ext4/ext4.h                    |   15 ++++-
 fs/ext4/ialloc.c                  |    3 +
 fs/ext4/inode.c                   |   15 +++++
 fs/ext4/namei.c                   |  102 +++++++++++++++++++++++++++++=
+++++++-
 fs/ext4/super.c                   |   61 ++++++++++++++++++++--
 fs/ioctl.c                        |   62 ++++++++++++++++++++++
 fs/quota/dquot.c                  |   96 +++++++++++++++++++++++++++++=
++++--
 fs/quota/quota.c                  |    8 ++-
 fs/quota/quotaio_v2.h             |    6 +-
 include/linux/fs.h                |    3 +
 include/linux/quota.h             |    1=20
 include/linux/quotaops.h          |   16 ++++++
 include/uapi/linux/capability.h   |    1=20
 include/uapi/linux/fs.h           |    3 +
 include/uapi/linux/quota.h        |    6 +-
 kernel/sysctl.c                   |    9 +++
 kernel/user_namespace.c           |    4 +
 21 files changed, 416 insertions(+), 25 deletions(-)

--
Signature
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
