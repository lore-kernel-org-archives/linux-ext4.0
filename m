From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH RFC v2 0/6] ext4: yet another project quota
Date: Tue, 17 Mar 2015 08:40:19 +0300
Message-ID: <CALYGNiOS8gmxA+TLNX+zOuGt3mXEZ4i-mTt2hpN-Rh4VGTkjuQ@mail.gmail.com>
References: <20150310171133.23081.49616.stgit@buzz>
	<20150316165228.GT4934@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Li Xi <pkuelelixi@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33676 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbCQFkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Mar 2015 01:40:21 -0400
In-Reply-To: <20150316165228.GT4934@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 16, 2015 at 7:52 PM, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
> On Tue 10-03-15 20:22:04, Konstantin Khlebnikov wrote:
>> Projects quota allows to enforce disk quota for several subtrees or =
even
>> individual files on the filesystem. Each inode is marked with projec=
t-id
>> (independently from uid and gid) and accounted into corresponding pr=
oject
>> quota. New files inherits project id from directory where they are c=
reated.
>>
>> This is must-have feature for deploying lightweight containers.
>> Also project quota can tell size of subtree without doing recursive =
'du'.
>>
>> This patchset adds project id and quota into ext4.
>>
>> This time I've prepared patches also for e2fsprogs and quota-tools.
>>
>> All patches are available at github:
>> https://github.com/koct9i/linux --branch project
>> https://github.com/koct9i/e2fsprogs --branch project
>> https://github.com/koct9i/quota-tools --branch project
>>
>> Porposed behavior is similar to project quota in XFS:
>>
>> * all inode are marked with project id
>> * new files inherits project id from parent directory
>> * project quota accounts inodes and enforces limits
>> * cross-project link and rename operations are restricted
>
>   Thanks for the patches and sorry for taking a long time to look int=
o
> them. I like your patches and they looks mostly fine to me but can we
> *please* start with making things completely compatible with how XFS =
works?
> I understand that may seem broken / not useful for your usecase but
> consistency among filesystems is really important.
>
> I was talking with Dave Chinner last week and we agreed that the dire=
ction
> you are changing things makes sense but getting things compatible wit=
h how
> they were for 15 years in XFS is an important first step (because the=
re may
> be people with other usecases depending on the old behavior and they =
would
> get confused by ext4 behaving differently). After we have compatible =
code
> in, we can add your fs.protected_projects thing on top of that (and a=
lso
> support it in XFS to stay compatible).
>
>
>> Differences:
>>
>> There is no flag similar to XFS_XFLAG_PROJINHERIT (which allows to d=
isable
>> project id inheritance), instead of that project which userspace see=
s as '0'
>> (in nested user-name space that might be actually non-zero project) =
acts as
>> default project where restrictions for link/rename are ignored.
>> (also see below, in "why new ioctl" part)
>>
>> This implementation adds shortcut for moving files from one project =
into
>> another: non-directory inodes with n_link =3D=3D 1 are transferred w=
ithout
>> copying (XFS in this case returns -EXDEV and userspace have to copy =
file).
>>
>> In XFS file owner (or process with CAP_FOWNER) can set set any proje=
ct id,
>> XFS permits changing project id only from init user-namespace.
>>
>> This patchset adds sysctl fs.protected_projects. By default it's 0 a=
nd project
>> id acts as XFS project. Setting it to 1 makes chaning project id pri=
viliged
>> operation which requires CAP_SYS_RESOURCE in current user-namespace,=
 changing
>> project id mapping for nested user-namespace also requires that capa=
bility.
>> Thus there are two levels of control: project id mapping in user-ns =
defines set
>> of permitted projects and capability protects operations within this=
 set.
>>
>> I see no problems with supporting all this in XFS, all difference in=
 interface.
>>
>> Ext4 layout
>> -----------
>>
>> Project id introduce ro-compatible feature 'project'.
>>
>> Inode project id is stored in place of obsolete field 'i_faddr' (tha=
t trick was
>> suggested by Darrick J. Wong in previous discussions of project quot=
a).
>> Linux never used that field and present fsck checks that it contains=
 zero.
>>
>> Quota information is stored in special inode =E2=84=9611 (by default=
 only 10 inodes are
>> reserved for special usage, I've add option to resize2fs to reserve =
more).
>> (see e2fsprogs patches for details) For symmetry with other quotas i=
node number
>> is stored in superblock.
>>
>> Project quota supports only modern 'hidden' journaled mode.
>>
>> Interface
>> ---------
>>
>> Interface for changing limits / query current usage is common vfs qu=
otactl()
>> where quotatype =3D PRJQUOTA =3D 2. User can query current state of =
any project
>> mapped into user-ns, changing of limits requires CAP_SYS_ADMIN in in=
it user-ns.
>>
>> Two new ioctls for getting / changing inode project id:
>> int ioctl(fd, FS_IOC_GETPROJECT, unsigned *project);
>> int ioctl(fd, FS_IOC_SETPROJECT, unsigned *project);
>>
>> They acts as interface for super-block methods get_project / set_pro=
ject
>> Generic code checks permissions, does project id translation in user=
-namespace
>> mapping, grabs write-access to the filesystem, locks i_mutex for set=
 opetaion.
>> Filesystem method only updates inode and transfers project quota.
>>
>> No new mount options added. Disk usage tracking is enabled at mount.
>> Limits are enabeld later by "quotaon".
>>
>> (BTW why journalled quota doesn't enable limits right at the time of=
 mounting?)
>   Well, mostly historical reasons :) The biggest probably was that to
> properly initialize quotas (or fix them if quota file gets corrupted)=
 you
> have to still run quotacheck and for that kernel mustn't touch the fi=
les.
> At the time when I was writing journaled quotas I didn't feel like ad=
ding
> quotacheck support into e2fsck... We eventually did that anyway for s=
upport
> of quota in system files but how we did that was actually based on th=
e
> experience I had from the journaled quota lesson ;).
>
>> Why new ioctls?
>> ---------------
>>
>> XFS has it's own interface for that: XFS_IOC_FSGETXATTR / XFS_IOC_FS=
SETXATTR.
>> But it has several flaws and doesn't fit for a role of generic inter=
face.
>>
>> It contains a lot of xfs-specific flags and racy by design: set oper=
ation
>> commits all fields at once thus it's used in sequence get-change-set=
 without
>> any lock, Concurrent updates from user space will collide.

>   Sure but that's the case for generic GETFLAGS / SETFLAGS interface =
as
> well.

In this case we care only about project id. We can make interface clear=
,
non-racy and do it in just one syscall instead of two.

>
>> Also xfs has flag XFS_XFLAG_PROJINHERIT which tells should new files=
 inherit
>> project id from parent directory or not. This flag is barely useful =
and only
>> makes everything complicated. Even tools in xfsprogs don't use it: t=
hey always
>> set it together with project id and clears when set project id back =
to zero.
>   I think this is about balance - adding the support for the PROJINHE=
RIT flag
> costs us close to nothing and we get a compatibility with XFS. So eve=
n though
> the usefulness of that flag is doubtful, I think the additional
> compatibility is worth it.

There're only few free bits left. This bit gives nothing, xfsprogs can =
change it
but project quota management doesn't uses it. It gives nothing but comp=
lication.

Also this bit makes difference only for accounting directories itself
and it's internal
structures. This is pretty fs-specific thing.

>
>> And the main reason: this compatibility gives nothing. The only user=
 of xfs
>> ioctl which I've found is the xfsprogs. And these tools check filesy=
stem name
>> and don't work anywhere except 'xfs'.
>   The fact that you didn't find any other user doesn't mean there isn=
't
> any. And historically if we though "nobody could be relying on this",=
 we
> were sometimes proven wrong - a few years later when it was *much* mo=
re
> painful to make things compatible.
>
> Here we speak about new feature for the filesystem so compatibility
> requirements aren't that strong but still I find the case that the sa=
me
> ioctl will just work on ext4 as it does on xfs more appealing than cr=
eating
> a new simpler generic ioctl. That way userspace doesn't have to care =
on
> which filesystem it is working or whether the current kernel already
> supports the new ioctl for XFS. So please use the XFS interface is Li=
 Xi
> does in his patches.

Please consider this as _new_ feature which has compatible behaviour
from user's point of view. That's perfect time to fix its birth defects=
 and
redesign behavior to satisfy expectations of new users. I do not care
about migration from xfs to ext4, that's not my case. I do not care abo=
ut
mythical closed source software which might use this interface.

As I already said ioctl compatibility gives nothing but legacy problems=
=2E
Unexpected apperance of partial compatibility might be a nightmare.
And I've seen a lot when I worked with mixed containerized evironments.
it emerges untested and unexpected combinations of old and new software=
=2E
But, of course not in this case because nobody uses this interface exce=
pt
xfsprogs. And as I said without update it works only with XFS.

Also that's ioctl is so poorly designed for generic usage so resulting =
code
looks like a shit. I just cannot add this into the kernel without any
good reason.

I've implemented interface and behaviour xfs-compatible enough to add
support of that into xfsprogs/xfstests in few lines. That's my next ste=
p after
polishing support in quota-tools.

>
>                                                                 Honza
>
>> Links
>> -----
>>
>> [1] 2014-12-09  ext4: add project quota support by Li Xi
>> http://marc.info/?l=3Dlinux-fsdevel&m=3D141810265603565&w=3D2
>>
>> [2] 2014-01-28  A draft for making ext4 support project quota by Zhe=
ng Liu
>> http://marc.info/?l=3Dlinux-ext4&m=3D139089109605795&w=3D2
>>
>> [3] 2012-07-09  introduce extended inode owner identifier v10 by Dmi=
try Monakhov
>> http://thread.gmane.org/gmane.linux.file-systems/65752
>>
>> [4] 2010-02-08  Introduce subtree quota support by Dmitry Monakhov
>> http://thread.gmane.org/gmane.comp.file-systems.ext4/17530
>>
>>
>> ---
>>
>> Konstantin Khlebnikov (6):
>>       fs: vfs ioctls for managing project id
>>       fs: protected project id
>>       quota: generic project quota
>>       ext4: support project id and project quota
>>       ext4: add shortcut for moving files across projects
>>       ext4: mangle statfs results accourding to project quota usage =
and limits
>>
>>
>>  Documentation/filesystems/Locking |    4 +
>>  Documentation/filesystems/vfs.txt |    8 +++
>>  Documentation/sysctl/fs.txt       |   16 ++++++
>>  fs/compat_ioctl.c                 |    2 +
>>  fs/ext4/ext4.h                    |   15 ++++-
>>  fs/ext4/ialloc.c                  |    3 +
>>  fs/ext4/inode.c                   |   15 +++++
>>  fs/ext4/namei.c                   |  102 ++++++++++++++++++++++++++=
++++++++++-
>>  fs/ext4/super.c                   |   61 ++++++++++++++++++++--
>>  fs/ioctl.c                        |   62 ++++++++++++++++++++++
>>  fs/quota/dquot.c                  |   96 ++++++++++++++++++++++++++=
+++++++--
>>  fs/quota/quota.c                  |    8 ++-
>>  fs/quota/quotaio_v2.h             |    6 +-
>>  include/linux/fs.h                |    3 +
>>  include/linux/quota.h             |    1
>>  include/linux/quotaops.h          |   16 ++++++
>>  include/uapi/linux/capability.h   |    1
>>  include/uapi/linux/fs.h           |    3 +
>>  include/uapi/linux/quota.h        |    6 +-
>>  kernel/sysctl.c                   |    9 +++
>>  kernel/user_namespace.c           |    4 +
>>  21 files changed, 416 insertions(+), 25 deletions(-)
>>
>> --
>> Signature
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
