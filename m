From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 01/30] ext4: EXT4 snapshots (Experimental)
Date: Tue, 7 Jun 2011 12:28:12 +0300
Message-ID: <BANLkTi=i_42H4mDWRyg325TFw=Z-bVnFqQ@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-2-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061512490.3934@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58730 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1FGJ2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 05:28:14 -0400
Received: by wwk4 with SMTP id 4so2282646wwk.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 02:28:12 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106061512490.3934@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 6, 2011 at 5:50 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:
>
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> Built-in snapshots support for ext4.
>> Requires that the filesystem has the has_snapshot and exclude_bitmap
>> features and that block size is equal to system page size.
>> Snapshots are not supported with 64bit and meta_bg features and the
>> filesystem must be mounted with ordered data mode.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/Kconfig =A0 =A0 =A0 =A0 =A0| =A0 11 +++
>> =A0fs/ext4/Makefile =A0 =A0 =A0 =A0 | =A0 =A02 +
>> =A0fs/ext4/balloc.c =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0fs/ext4/ext4.h =A0 =A0 =A0 =A0 =A0 | =A0 15 ++++
>> =A0fs/ext4/ext4_jbd2.c =A0 =A0 =A0| =A0 =A03 +
>> =A0fs/ext4/ext4_jbd2.h =A0 =A0 =A0| =A0 25 ++++++
>> =A0fs/ext4/extents.c =A0 =A0 =A0 =A0| =A0 =A03 +
>> =A0fs/ext4/file.c =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0fs/ext4/ialloc.c =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0fs/ext4/inode.c =A0 =A0 =A0 =A0 =A0| =A0 =A03 +
>> =A0fs/ext4/ioctl.c =A0 =A0 =A0 =A0 =A0| =A0 =A03 +
>> =A0fs/ext4/mballoc.c =A0 =A0 =A0 =A0| =A0 =A01 +
>> =A0fs/ext4/namei.c =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
>> =A0fs/ext4/resize.c =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0fs/ext4/snapshot.h =A0 =A0 =A0 | =A0193 +++++++++++++++++++++++++=
+++++++++++++++++++++
>> =A0fs/ext4/super.c =A0 =A0 =A0 =A0 =A0| =A0 43 ++++++++++
>> =A016 files changed, 307 insertions(+), 0 deletions(-)
>> =A0create mode 100644 fs/ext4/snapshot.h
>> =A0create mode 100644 fs/ext4/snapshot_debug.h
>>
>> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
>> index 9ed1bb1..8970525 100644
>> --- a/fs/ext4/Kconfig
>> +++ b/fs/ext4/Kconfig
>> @@ -83,3 +83,14 @@ config EXT4_DEBUG
>>
>> =A0 =A0 =A0 =A0 If you select Y here, then you will be able to turn =
on debugging
>> =A0 =A0 =A0 =A0 with a command such as "echo 1 > /sys/kernel/debug/e=
xt4/mballoc-debug"
>> +
>> +config EXT4_FS_SNAPSHOT
>> + =A0 =A0 bool "EXT4 snapshots (Experimental)"
>> + =A0 =A0 depends on EXT4_FS && EXPERIMENTAL
>> + =A0 =A0 default n
>> + =A0 =A0 help
>> + =A0 =A0 =A0 Built-in snapshots support for ext4.
>> + =A0 =A0 =A0 Requires that the filesystem has the has_snapshot and =
exclude_bitmap
>> + =A0 =A0 =A0 features and that block size is equal to system page s=
ize.
>> + =A0 =A0 =A0 Snapshots are not supported with 64bit and meta_bg fea=
tures and the
>> + =A0 =A0 =A0 filesystem must be mounted with ordered data mode.
>
> What exactly do you mean by not supported with 64bit feature ? Maybe =
I
> am being dense, but I do not get it.

I mean snapshots and 64bit features are mutually exclusive.
Is that what you got or do I need to make it more clear?

>
>> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
>> index 058b54d..16a779d 100644
>> --- a/fs/ext4/Makefile
>> +++ b/fs/ext4/Makefile
>> @@ -19,3 +19,5 @@ ext4-y =A0 =A0 =A0:=3D balloc.o bitmap.o dir.o fil=
e.o fsync.o ialloc.o inode.o page-io.o \
>> =A0ext4-$(CONFIG_EXT4_FS_XATTR) =A0 =A0 =A0 =A0 +=3D xattr.o xattr_u=
ser.o xattr_trusted.o
>> =A0ext4-$(CONFIG_EXT4_FS_POSIX_ACL) =A0 =A0 +=3D acl.o
>> =A0ext4-$(CONFIG_EXT4_FS_SECURITY) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D x=
attr_security.o
>> +ext4-$(CONFIG_EXT4_FS_SNAPSHOT) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D sna=
pshot.o snapshot_ctl.o
>> +ext4-$(CONFIG_EXT4_FS_SNAPSHOT) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D sna=
pshot_inode.o snapshot_buffer.o
>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>> index 1288f80..350f502 100644
>> --- a/fs/ext4/balloc.c
>> +++ b/fs/ext4/balloc.c
>> @@ -20,6 +20,7 @@
>> =A0#include "ext4.h"
>> =A0#include "ext4_jbd2.h"
>> =A0#include "mballoc.h"
>> +#include "snapshot.h"
>>
>> =A0/*
>> =A0 * balloc.c contains the blocks allocation and deallocation routi=
nes
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index f495b22..ca25e67 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -886,6 +886,20 @@ struct ext4_inode_info {
>> =A0#define EXT2_FLAGS_SIGNED_HASH =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x0001=
 =A0/* Signed dirhash in use */
>> =A0#define EXT2_FLAGS_UNSIGNED_HASH =A0 =A0 0x0002 =A0/* Unsigned di=
rhash in use */
>> =A0#define EXT2_FLAGS_TEST_FILESYS =A0 =A0 =A0 =A0 =A0 =A0 =A00x0004=
 =A0/* to test development code */
>> +#define EXT4_FLAGS_IS_SNAPSHOT =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x0010 /=
* Is a snapshot image */
>> +#define EXT4_FLAGS_FIX_SNAPSHOT =A0 =A0 =A0 =A0 =A0 =A0 =A00x0020 /=
* Corrupted snapshot */
>> +#define EXT4_FLAGS_FIX_EXCLUDE =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x0040 /=
* Bad exclude bitmap */
>
> Would not it be better to call it EXT4_FLAGS_BAD_SNAPSHOT and
> EXT4_FLAGS_BAD_EXCLUDE_BMAP ?

Sure. Will do.

>
>> +
>> +#define EXT4_SET_FLAGS(sb, mask) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SB(sb)->s_es->s_flags |=3D cpu_to_le3=
2(mask); \
>> + =A0 =A0 } while (0)
>> +#define EXT4_CLEAR_FLAGS(sb, mask) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SB(sb)->s_es->s_flags &=3D ~cpu_to_le=
32(mask);\
>> + =A0 =A0 } while (0)
>> +#define EXT4_TEST_FLAGS(sb, mask) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (EXT4_SB(sb)->s_es->s_flags & cpu_to_le32(mask))
>>
>> =A0/*
>> =A0 * Mount flags
>> @@ -1351,6 +1365,7 @@ static inline void ext4_clear_state_flags(stru=
ct ext4_inode_info *ei)
>> =A0#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x0010
>> =A0#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A0 0x0020
>> =A0#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 0x0040
>> +#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A00x0080 /* Ext4 has s=
napshots */
>>
>> =A0#define EXT4_FEATURE_INCOMPAT_COMPRESSION =A0 =A00x0001
>> =A0#define EXT4_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0x0002
>> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
>> index 6e272ef..560020d 100644
>> --- a/fs/ext4/ext4_jbd2.c
>> +++ b/fs/ext4/ext4_jbd2.c
>> @@ -1,8 +1,11 @@
>> =A0/*
>> =A0 * Interface between ext4 and JBD
>> + *
>> + * Snapshot metadata COW hooks, Amir Goldstein <amir73il@users.sf.n=
et>, 2011
>> =A0 */
>>
>> =A0#include "ext4_jbd2.h"
>> +#include "snapshot.h"
>>
>> =A0#include <trace/events/ext4.h>
>>
>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
>> index e25e99b..8ffffb1 100644
>> --- a/fs/ext4/ext4_jbd2.h
>> +++ b/fs/ext4/ext4_jbd2.h
>> @@ -10,6 +10,8 @@
>> =A0 * option, any later version, incorporated herein by reference.
>> =A0 *
>> =A0 * Ext4-specific journaling extensions.
>> + *
>> + * Snapshot extra COW credits, Amir Goldstein <amir73il@users.sf.ne=
t>, 2011
>> =A0 */
>>
>> =A0#ifndef _EXT4_JBD2_H
>> @@ -18,6 +20,7 @@
>> =A0#include <linux/fs.h>
>> =A0#include <linux/jbd2.h>
>> =A0#include "ext4.h"
>> +#include "snapshot.h"
>>
>> =A0#define EXT4_JOURNAL(inode) =A0(EXT4_SB((inode)->i_sb)->s_journal=
)
>>
>> @@ -272,6 +275,11 @@ static inline int ext4_should_journal_data(stru=
ct inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (!S_ISREG(inode->i_mode))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> +#ifdef CONFIG_EXT4_FS_SNAPSHOT
>> + =A0 =A0 if (EXT4_SNAPSHOTS(inode->i_sb))
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* snapshots enforce ordered data */
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +#endif
>> =A0 =A0 =A0 if (test_opt(inode->i_sb, DATA_FLAGS) =3D=3D EXT4_MOUNT_=
JOURNAL_DATA)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> =A0 =A0 =A0 if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA)=
)
>> @@ -285,6 +293,11 @@ static inline int ext4_should_order_data(struct=
 inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (!S_ISREG(inode->i_mode))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +#ifdef CONFIG_EXT4_FS_SNAPSHOT
>> + =A0 =A0 if (EXT4_SNAPSHOTS(inode->i_sb))
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* snapshots enforce ordered data */
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> +#endif
>> =A0 =A0 =A0 if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA)=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (test_opt(inode->i_sb, DATA_FLAGS) =3D=3D EXT4_MOUNT_=
ORDERED_DATA)
>> @@ -298,6 +311,11 @@ static inline int ext4_should_writeback_data(st=
ruct inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (EXT4_JOURNAL(inode) =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> +#ifdef CONFIG_EXT4_FS_SNAPSHOT
>> + =A0 =A0 if (EXT4_SNAPSHOTS(inode->i_sb))
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* snapshots enforce ordered data */
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +#endif
>> =A0 =A0 =A0 if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA)=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (test_opt(inode->i_sb, DATA_FLAGS) =3D=3D EXT4_MOUNT_=
WRITEBACK_DATA)
>> @@ -320,6 +338,11 @@ static inline int ext4_should_dioread_nolock(st=
ruct inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (!S_ISREG(inode->i_mode))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +#ifdef CONFIG_EXT4_FS_SNAPSHOT
>> + =A0 =A0 if (EXT4_SNAPSHOTS(inode->i_sb))
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* XXX: should snapshots support dioread_n=
olock? */
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +#endif
>> =A0 =A0 =A0 if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 if (ext4_should_journal_data(inode))
>> @@ -327,4 +350,6 @@ static inline int ext4_should_dioread_nolock(str=
uct inode *inode)
>> =A0 =A0 =A0 return 1;
>> =A0}
>
> Since EXT4_SNAPSHOTS(sb) returns 0 when not configured in, I do not
> think those ifdefs are needed.
>

true. will fix.

>>
>> +#ifdef CONFIG_EXT4_FS_SNAPSHOT
>> +#endif
>> =A0#endif =A0 =A0 =A0 /* _EXT4_JBD2_H */
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 7296cd1..0c3ea93 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -18,6 +18,8 @@
>> =A0 * You should have received a copy of the GNU General Public Lice=
ns
>> =A0 * along with this program; if not, write to the Free Software
>> =A0 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA =A002=
111-
>> + *
>> + * Snapshot move-on-write (MOW), Yongqiang Yang <xiaoqiangnk@gmail.=
com>, 2011
>> =A0 */
>>
>> =A0/*
>> @@ -43,6 +45,7 @@
>> =A0#include <linux/fiemap.h>
>> =A0#include "ext4_jbd2.h"
>> =A0#include "ext4_extents.h"
>> +#include "snapshot.h"
>>
>> =A0static int ext4_ext_truncate_extend_restart(handle_t *handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 struct inode *inode,
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index 7b80d54..60b3b19 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -28,6 +28,7 @@
>> =A0#include "ext4_jbd2.h"
>> =A0#include "xattr.h"
>> =A0#include "acl.h"
>> +#include "snapshot.h"
>>
>> =A0/*
>> =A0 * Called when an inode is released. Note that this is different
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index 2fd3b0e..831d49a 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -28,6 +28,7 @@
>> =A0#include "ext4_jbd2.h"
>> =A0#include "xattr.h"
>> =A0#include "acl.h"
>> +#include "snapshot.h"
>>
>> =A0#include <trace/events/ext4.h>
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 4ccb6eb..a597ff1 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -20,6 +20,8 @@
>> =A0 * =A0 (jj@sunsite.ms.mff.cuni.cz)
>> =A0 *
>> =A0 * =A0Assorted race fixes, rewrite of ext4_get_block() by Al Viro=
, 2000
>> + *
>> + * =A0Snapshot inode extensions, Amir Goldstein <amir73il@users.sf.=
net>, 2011
>> =A0 */
>>
>> =A0#include <linux/module.h>
>> @@ -49,6 +51,7 @@
>> =A0#include "ext4_extents.h"
>>
>> =A0#include <trace/events/ext4.h>
>> +#include "snapshot.h"
>>
>> =A0#define MPAGE_DA_EXTENT_TAIL 0x01
>>
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index eb3bc2f..a426332 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -5,6 +5,8 @@
>> =A0 * Remy Card (card@masi.ibp.fr)
>> =A0 * Laboratoire MASI - Institut Blaise Pascal
>> =A0 * Universite Pierre et Marie Curie (Paris VI)
>> + *
>> + * Snapshot control API, Amir Goldstein <amir73il@users.sf.net>, 20=
11
>> =A0 */
>>
>> =A0#include <linux/fs.h>
>> @@ -17,6 +19,7 @@
>> =A0#include <asm/uaccess.h>
>> =A0#include "ext4_jbd2.h"
>> =A0#include "ext4.h"
>> +#include "snapshot.h"
>>
>> =A0long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned lon=
g arg)
>> =A0{
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 2be85af..4952b7b 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -25,6 +25,7 @@
>> =A0#include <linux/debugfs.h>
>> =A0#include <linux/slab.h>
>> =A0#include <trace/events/ext4.h>
>> +#include "snapshot.h"
>>
>> =A0/*
>> =A0 * MUSTDO:
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index ad87584..b70fa13 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -39,6 +39,7 @@
>>
>> =A0#include "xattr.h"
>> =A0#include "acl.h"
>> +#include "snapshot.h"
>>
>> =A0/*
>> =A0 * define how far ahead to read directories while searching them.
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index a11c00a..ee9b999 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -15,6 +15,7 @@
>> =A0#include <linux/slab.h>
>>
>> =A0#include "ext4_jbd2.h"
>> +#include "snapshot.h"
>
> It would be better for reviewers if you'll add those includes when yo=
u
> start using them.
>

OK. I can do that.

>>
>> =A0#define outside(b, first, last) =A0 =A0 =A0((b) < (first) || (b) =
>=3D (last))
>> =A0#define inside(b, first, last) =A0 =A0 =A0 ((b) >=3D (first) && (=
b) < (last))
>> diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
>> new file mode 100644
>> index 0000000..a927090
>> --- /dev/null
>> +++ b/fs/ext4/snapshot.h
>> @@ -0,0 +1,193 @@
>> +/*
>> + * linux/fs/ext4/snapshot.h
>> + *
>> + * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
>> + *
>> + * Copyright (C) 2008-2011 CTERA Networks
>> + *
>> + * This file is part of the Linux kernel and is made available unde=
r
>> + * the terms of the GNU General Public License, version 2, or at yo=
ur
>> + * option, any later version, incorporated herein by reference.
>> + *
>> + * Ext4 snapshot extensions.
>
> This is great place to write more about snapshot design and
> implementation. If it is added later in a different file, then ignore=
 it
> :).

the inline documentation is scattered among several patches.
I should probably also add Documentation/ext4_snapshots.txt
with some design and overview information.
And perhaps insert a short short version of it here ;-)

>
>> + */
>> +
>> +#ifndef _LINUX_EXT4_SNAPSHOT_H
>> +#define _LINUX_EXT4_SNAPSHOT_H
>> +
>> +#include <linux/version.h>
>> +#include <linux/delay.h>
>> +#include "ext4.h"
>> +
>> +
>> +/*
>> + * use signed 64bit for snapshot image addresses
>> + * negative addresses are used to reference snapshot meta blocks
>> + */
>> +#define ext4_snapblk_t long long
>
> typedef signed long long int ext4_snapblk_t maybe ?

1. checkpatch doesn't like adding new typedef to the kernel
2. I am in th process of removing that define altogether

>
>> +
>> +/*
>> + * We assert that file system block size =3D=3D page size (on mount=
 time)
>> + * and that the first file system block is block 0 (on snapshot cre=
ate).
>> + * Snapshot inode direct blocks are reserved for snapshot meta bloc=
ks.
>> + * Snapshot inode single indirect blocks are not used.
>> + * Snapshot image starts at the first double indirect block, so all=
 blocks in
>> + * Snapshot image block group blocks are mapped by a single DIND bl=
ock:
>> + * 4k: 32k blocks_per_group =3D 32 IND (4k) blocks =3D 32 groups pe=
r DIND
>> + * 8k: 64k blocks_per_group =3D 32 IND (8k) blocks =3D 64 groups pe=
r DIND
>> + * 16k: 128k blocks_per_group =3D 32 IND (16k) blocks =3D 128 group=
s per DIND
>> + */
>> +#define SNAPSHOT_BLOCK_SIZE =A0 =A0 =A0 =A0 =A0PAGE_SIZE
>> +#define SNAPSHOT_BLOCK_SIZE_BITS =A0 =A0 PAGE_SHIFT
>> +#define =A0 =A0 =A0SNAPSHOT_ADDR_PER_BLOCK =A0 =A0 =A0 =A0 (SNAPSHO=
T_BLOCK_SIZE / sizeof(__u32))
>
>> +#define SNAPSHOT_ADDR_PER_BLOCK_BITS (SNAPSHOT_BLOCK_SIZE_BITS - 2)
>
> #define SNAPSHOT_ADDR_PER_BLOCK =A0 =A0 =A0 =A0 (1 << SNAPSHOT_BLOCK_=
SIZE_BITS )

Thanks.

>
>> +#define SNAPSHOT_DIR_BLOCKS =A0 =A0 =A0 =A0 =A0EXT4_NDIR_BLOCKS
>> +#define SNAPSHOT_IND_BLOCKS =A0 =A0 =A0 =A0 =A0SNAPSHOT_ADDR_PER_BL=
OCK
>> +
>> +#define SNAPSHOT_BLOCKS_PER_GROUP_BITS =A0 =A0 =A0 (SNAPSHOT_BLOCK_=
SIZE_BITS + 3)
>> +#define SNAPSHOT_BLOCKS_PER_GROUP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 (1<<SNAPSHOT_BLOCKS_PER_GROUP_BITS) /* 8*PAGE_SIZE */
>
>> +#define SNAPSHOT_BLOCK_GROUP(block) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 ((block)>>SNAPSHOT_BLOCKS_PER_GROUP_BITS)
>> +#define SNAPSHOT_BLOCK_GROUP_OFFSET(block) =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 \
>> + =A0 =A0 ((block)&(SNAPSHOT_BLOCKS_PER_GROUP-1))
>
> formating is wrong.
>

what do you mean?

>> +#define SNAPSHOT_BLOCK_TUPLE(block) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 (ext4_fsblk_t)SNAPSHOT_BLOCK_GROUP_OFFSET(block), =A0 =A0 =
=A0 \
>> + =A0 =A0 (ext4_fsblk_t)SNAPSHOT_BLOCK_GROUP(block)
>
> This is confusing, but is you're using it really often, so be it.

I use it in debug prints.
if I turn them into fixed trace points, this define can go away.
checkpatch doesn't like it either...

>
>> +#define SNAPSHOT_IND_PER_BLOCK_GROUP_BITS =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0\
>> + =A0 =A0 (SNAPSHOT_BLOCKS_PER_GROUP_BITS-SNAPSHOT_ADDR_PER_BLOCK_BI=
TS)
>> +#define SNAPSHOT_IND_PER_BLOCK_GROUP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (1<<SNAPSHOT_IND_PER_BLOCK_GROUP_BITS) /* 32 */
>> +#define SNAPSHOT_DIND_BLOCK_GROUPS_BITS =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 (SNAPSHOT_ADDR_PER_BLOCK_BITS-SNAPSHOT_IND_PER_BLOCK_GROUP=
_BITS)
>> +#define SNAPSHOT_DIND_BLOCK_GROUPS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (1<<SNAPSHOT_DIND_BLOCK_GROUPS_BITS)
>
> formating

?

>
>> +
>> +#define SNAPSHOT_BLOCK_OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 (SNAPSHOT_DIR_BLOCKS+SNAPSHOT_IND_BLOCKS)
>> +#define SNAPSHOT_BLOCK(iblock) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 ((ext4_snapblk_t)(iblock) - SNAPSHOT_BLOCK_OFFSET)
>> +#define SNAPSHOT_IBLOCK(block) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (ext4_fsblk_t)((block) + SNAPSHOT_BLOCK_OFFSET)
>
> I do not see SNAPSHOT_BLOCK() defined anywhere.
>

Do you mean you don't see it used anywhere?
It is used by later patches, but I do need to document it's meaning her=
e.

>> +
>> +
>> +
>> +#ifdef CONFIG_EXT4_FS_SNAPSHOT
>> +#define EXT4_SNAPSHOT_VERSION "ext4 snapshot v1.0.13-6 (2-May-2010)=
"
>> +
>> +#define SNAPSHOT_BYTES_OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 (SNAPSHOT_BLOCK_OFFSET << SNAPSHOT_BLOCK_SIZE_BITS)
>> +#define SNAPSHOT_ISIZE(size) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 ((size) + SNAPSHOT_BYTES_OFFSET)
>> +/* Snapshot block device size is recorded in i_disksize */
>> +#define SNAPSHOT_SET_SIZE(inode, size) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (EXT4_I(inode)->i_disksize =3D SNAPSHOT_ISIZE(size))
>
> I do not have a clue what that means. And to be honest I am getting a
> bit lost in macros, could you add some comments explaining what it is
> used for ?

Sure, I'll do that.

>
>> +#define SNAPSHOT_SIZE(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (EXT4_I(inode)->i_disksize - SNAPSHOT_BYTES_OFFSET)
>> +#define SNAPSHOT_SET_BLOCKS(inode, blocks) =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 \
>> + =A0 =A0 SNAPSHOT_SET_SIZE((inode), =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (loff_t)(blocks) << SNAPSH=
OT_BLOCK_SIZE_BITS)
>> +#define SNAPSHOT_BLOCKS(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (ext4_fsblk_t)(SNAPSHOT_SIZE(inode) >> SNAPSHOT_BLOCK_SIZE=
_BITS)
>> +/* Snapshot shrink/merge/clean progress is exported via i_size */
>> +#define SNAPSHOT_PROGRESS(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 (ext4_fsblk_t)((inode)->i_size >> SNAPSHOT_BLOCK_SIZE_BITS=
)
>> +#define SNAPSHOT_SET_ENABLED(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 i_size_write((inode), SNAPSHOT_SIZE(inode))
>> +#define SNAPSHOT_SET_PROGRESS(inode, blocks) =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 \
>> + =A0 =A0 snapshot_size_extend((inode), (blocks))
>> +/* Disabled/deleted snapshot i_size is 1 block, to allow read of su=
per block */
>> +#define SNAPSHOT_SET_DISABLED(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 snapshot_size_truncate((inode), 1)
>> +/* Removed snapshot i_size and i_disksize are 0, since all blocks w=
ere freed */
>> +#define SNAPSHOT_SET_REMOVED(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 EXT4_I(inode)->i_disksize =3D 0; =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 snapshot_size_truncate((inode), 0); =A0 =A0=
 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 } while (0)
>> +
>> +static inline void snapshot_size_extend(struct inode *inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t blocks)
>> +{
>> + =A0 =A0 i_size_write((inode), (loff_t)(blocks) << SNAPSHOT_BLOCK_S=
IZE_BITS);
>> +}
>> +
>> +static inline void snapshot_size_truncate(struct inode *inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t blocks)
>> +{
>> + =A0 =A0 loff_t i_size =3D (loff_t)blocks << SNAPSHOT_BLOCK_SIZE_BI=
TS;
>> +
>> + =A0 =A0 i_size_write(inode, i_size);
>> + =A0 =A0 truncate_inode_pages(&inode->i_data, i_size);
>> +}
>> +
>> +/* Is ext4 configured for snapshots support? */
>> +static inline int EXT4_SNAPSHOTS(struct super_block *sb)
>> +{
>> + =A0 =A0 return EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEATURE_RO_COMPAT_HAS=
_SNAPSHOT);
>> +}
>> +
>> +#define ext4_snapshot_cow(handle, inode, block, bh, cow) 0
>> +
>> +#define ext4_snapshot_move(handle, inode, block, pcount, move) (0)
>> +
>> +/*
>> + * Block access functions
>> + */
>> +
>> +
>> +
>> +/* snapshot_ctl.c */
>> +
>> +
>> +static inline int init_ext4_snapshot(void)
>> +{
>> + =A0 =A0 return 0;
>> +}
>> +
>> +static inline void exit_ext4_snapshot(void)
>> +{
>> +}
>> +
>> +
>> +
>> +
>> +
>> +#else /* CONFIG_EXT4_FS_SNAPSHOT */
>> +
>> +/* Snapshot NOP macros */
>> +#define EXT4_SNAPSHOTS(sb) (0)
>> +#define SNAPMAP_ISCOW(cmd) =A0 (0)
>> +#define SNAPMAP_ISMOVE(cmd) =A0 =A0 (0)
>> +#define SNAPMAP_ISSYNC(cmd) =A0(0)
>> +#define IS_COWING(handle) =A0 =A0(0)
>> +
>> +#define ext4_snapshot_load(sb, es, ro) (0)
>> +#define ext4_snapshot_destroy(sb)
>> +#define init_ext4_snapshot() (0)
>> +#define exit_ext4_snapshot()
>> +#define ext4_snapshot_active(sbi) (0)
>> +#define ext4_snapshot_file(inode) (0)
>> +#define ext4_snapshot_should_move_data(inode) (0)
>> +#define ext4_snapshot_test_excluded(handle, inode, block_to_free, c=
ount) (0)
>> +#define ext4_snapshot_list(inode) (0)
>> +#define ext4_snapshot_get_flags(ei, filp)
>> +#define ext4_snapshot_set_flags(handle, inode, flags) (0)
>> +#define ext4_snapshot_take(inode) (0)
>> +#define ext4_snapshot_update(inode_i_sb, cleanup, zero) (0)
>> +#define ext4_snapshot_has_active(sb) (NULL)
>> +#define ext4_snapshot_get_bitmap_access(handle, sb, grp, bh) (0)
>> +#define ext4_snapshot_get_write_access(handle, inode, bh) (0)
>> +#define ext4_snapshot_get_create_access(handle, bh) (0)
>> +#define ext4_snapshot_excluded(ac_inode) (0)
>> +#define ext4_snapshot_get_delete_access(handle, inode, block, pcoun=
t) (0)
>> +
>> +#define ext4_snapshot_get_move_access(handle, inode, block, pcount,=
 move) (0)
>> +#define ext4_snapshot_start_pending_cow(sbh)
>> +#define ext4_snapshot_end_pending_cow(sbh)
>> +#define ext4_snapshot_is_active(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
(0)
>> +#define ext4_snapshot_mow_in_tid(inode) =A0 =A0 =A0 =A0 =A0 =A0 =A0=
(1)
>> +
>> +#endif /* CONFIG_EXT4_FS_SNAPSHOT */
>> +#endif =A0 =A0 =A0 /* _LINUX_EXT4_SNAPSHOT_H */
>> diff --git a/fs/ext4/snapshot_debug.h b/fs/ext4/snapshot_debug.h
>> new file mode 100644
>> index 0000000..e69de29
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 414167a..2c345d1 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -48,6 +48,7 @@
>> =A0#include "xattr.h"
>> =A0#include "acl.h"
>> =A0#include "mballoc.h"
>> +#include "snapshot.h"
>>
>> =A0#define CREATE_TRACE_POINTS
>> =A0#include <trace/events/ext4.h>
>> @@ -2612,6 +2613,24 @@ static int ext4_feature_set_ok(struct super_b=
lock *sb, int readonly)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> + =A0 =A0 /* Enforce snapshots requirements: */
>> + =A0 =A0 if (EXT4_SNAPSHOTS(sb)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (EXT4_HAS_INCOMPAT_FEATURE(sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT4_FEATURE_INCOMPAT_META_BG|
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT4_FEATURE_INCOMPAT_64BIT)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_msg(sb, KERN_ERR,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "has_snaps=
hot feature cannot be mixed with "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "features:=
 meta_bg, 64bit");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> So what if the fs is mounted as readonly and has those incompatible f=
eatures
> ? Is it ok ?

It should be fine because:
1. you cannot take new snapshots when readonly
2. no changes to fs =3D no COW =3D no changes to snapshot

So if a future kernel will support mixing snapshots and 64it (I hope it=
 will),
then is should be ok to mount the 64bit fs with snapshots using this ke=
rnel.
maybe the snapshots could not be read from, but there should be no prob=
lem
reading the fs.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (EXT4_TEST_FLAGS(sb, EXT4_FLAGS_IS_SNAP=
SHOT)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_msg(sb, KERN_ERR,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "A snapsho=
t image must be mounted read-only. "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "If this i=
s an exported snapshot image, you "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "must run =
fsck -xy to make it writable.");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> =A0 =A0 =A0 return 1;
>> =A0}
>>
>> @@ -3194,6 +3213,15 @@ static int ext4_fill_super(struct super_block=
 *sb, void *data, int silent)
>>
>> =A0 =A0 =A0 blocksize =3D BLOCK_SIZE << le32_to_cpu(es->s_log_block_=
size);
>>
>> + =A0 =A0 /* Enforce snapshots blocksize =3D=3D pagesize */
>> + =A0 =A0 if (EXT4_SNAPSHOTS(sb) && blocksize !=3D PAGE_SIZE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_msg(sb, KERN_ERR,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshots=
 require that filesystem blocksize "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "(%d) be e=
qual to system page size (%lu)",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocksize,=
 PAGE_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto failed_mount;
>> + =A0 =A0 }
>
> I would rather see this test after the test for supported filesystem
> blocksize. It is only logical to check for the superset first.

right. makes sense.

>
>> +
>> =A0 =A0 =A0 if (blocksize < EXT4_MIN_BLOCK_SIZE ||
>> =A0 =A0 =A0 =A0 =A0 blocksize > EXT4_MAX_BLOCK_SIZE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_msg(sb, KERN_ERR,
>> @@ -3540,6 +3568,15 @@ no_journal:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto failed_mount_wq;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 /* Enforce journal ordered mode with snapshots */
>> + =A0 =A0 if (EXT4_SNAPSHOTS(sb) && !(sb->s_flags & MS_RDONLY) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 (!EXT4_SB(sb)->s_journal ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0test_opt(sb, DATA_FLAGS) !=3D EXT4_MOUN=
T_ORDERED_DATA)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_msg(sb, KERN_ERR,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshots=
 require journal ordered mode");
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto failed_mount4;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* The jbd2_journal_load will have done any necessary =
log recovery,
>> =A0 =A0 =A0 =A0* so we can safely mount the rest of the filesystem n=
ow.
>> @@ -4878,10 +4915,15 @@ static int __init ext4_init_fs(void)
>> =A0 =A0 =A0 err =3D register_filesystem(&ext4_fs_type);
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 err =3D init_ext4_snapshot();
>> + =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_fs;
>
> Is it really necessary to init snapshots after the filesystem
> registration ? I do not see reason why.

no, not really.
it actually only registers debugfs entries,
which can go somewhere else.
I will remove both init and exit funcs.

>
>>
>> =A0 =A0 =A0 ext4_li_info =3D NULL;
>> =A0 =A0 =A0 mutex_init(&ext4_li_mtx);
>> =A0 =A0 =A0 return 0;
>> +out_fs:
>> + =A0 =A0 unregister_filesystem(&ext4_fs_type);
>> =A0out:
>> =A0 =A0 =A0 unregister_as_ext2();
>> =A0 =A0 =A0 unregister_as_ext3();
>> @@ -4905,6 +4947,7 @@ out7:
>>
>> =A0static void __exit ext4_exit_fs(void)
>> =A0{
>> + =A0 =A0 exit_ext4_snapshot();
>> =A0 =A0 =A0 ext4_destroy_lazyinit_thread();
>> =A0 =A0 =A0 unregister_as_ext2();
>> =A0 =A0 =A0 unregister_as_ext3();
>>
>
> Thanks!
> -Lukas
>

I will fix some of the things you pointed out and post the 'full' serie=
s.
Thank you!

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
