From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 02/30] ext4: snapshot debugging support
Date: Tue, 7 Jun 2011 12:59:30 +0300
Message-ID: <BANLkTi=UJQAgPHT4w-jLYHLcbg531T=sRw@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-3-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061659400.3934@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37845 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1FGJ7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 05:59:31 -0400
Received: by wya21 with SMTP id 21so3420393wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 02:59:30 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106061659400.3934@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 6, 2011 at 6:08 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:
>
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> Control snapshot debug level via debugfs entry /ext4/snapshot-debug
>> and induce delay tests via debugfs entries /ext4/test-XXX-delay-msec=
=2E
>
> Wouldn't you rather consider adding fixed tracepoints ? I think
> tracepoints would be useful regardless on =A0this debufs interface.

I think you are right.
I was not aware of tracepoints back when I wrote this debugging interfa=
ce.
some of the debug print should definitely be converted to tracepoints,
especially the ones in the functions XXX_trace_cow and XXX_journal_trac=
e...

>
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/Makefile =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0fs/ext4/mballoc.c =A0 =A0 =A0 =A0| =A0 =A03 +
>> =A0fs/ext4/snapshot.h =A0 =A0 =A0 | =A0 =A09 ++++
>> =A0fs/ext4/snapshot_debug.h | =A0105 +++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A04 files changed, 118 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
>> index 16a779d..9981306 100644
>> --- a/fs/ext4/Makefile
>> +++ b/fs/ext4/Makefile
>> @@ -21,3 +21,4 @@ ext4-$(CONFIG_EXT4_FS_POSIX_ACL) =A0 =A0+=3D acl.o
>> =A0ext4-$(CONFIG_EXT4_FS_SECURITY) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D x=
attr_security.o
>> =A0ext4-$(CONFIG_EXT4_FS_SNAPSHOT) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D s=
napshot.o snapshot_ctl.o
>> =A0ext4-$(CONFIG_EXT4_FS_SNAPSHOT) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D s=
napshot_inode.o snapshot_buffer.o
>> +ext4-$(CONFIG_EXT4_FS_SNAPSHOT) =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D sna=
pshot_debug.o
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 4952b7b..42961bf 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -2657,10 +2657,13 @@ static void __init ext4_create_debugfs_entry=
(void)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 S_IRUGO | S_IWUSR,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 debugfs_dir,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 &mb_enable_debug);
>> + =A0 =A0 if (debugfs_dir)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_snapshot_create_debugfs_entry(debugfs=
_dir);
>> =A0}
>>
>> =A0static void ext4_remove_debugfs_entry(void)
>> =A0{
>> + =A0 =A0 ext4_snapshot_remove_debugfs_entry();
>
> I do not see it defined anywhere.

there must be a NOP macro somewhere.
the real function is in the omitted file snapshot_debug.c.

>
>> =A0 =A0 =A0 debugfs_remove(debugfs_debug);
>> =A0 =A0 =A0 debugfs_remove(debugfs_dir);
>> =A0}
>> diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
>> index a927090..52bfa52 100644
>> --- a/fs/ext4/snapshot.h
>> +++ b/fs/ext4/snapshot.h
>> @@ -18,6 +18,7 @@
>> =A0#include <linux/version.h>
>> =A0#include <linux/delay.h>
>> =A0#include "ext4.h"
>> +#include "snapshot_debug.h"
>>
>>
>> =A0/*
>> @@ -109,6 +110,14 @@
>> =A0static inline void snapshot_size_extend(struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t blocks)
>> =A0{
>> +#ifdef CONFIG_EXT4_DEBUG
>> + =A0 =A0 ext4_fsblk_t old_blocks =3D SNAPSHOT_PROGRESS(inode);
>> + =A0 =A0 ext4_fsblk_t max_blocks =3D SNAPSHOT_BLOCKS(inode);
>> +
>> + =A0 =A0 /* sleep total of tunable delay unit over 100% progress */
>
> What is this good for, it is not clear from the description.

the whole delay tunables are used for debugging concurrent
operations.
it is convenient to set the amount of delay for the entire operation
(like snapshot delete) and have these macros take care of
inserting small delay unit during the delete process.
Will add explanation.

>
>> + =A0 =A0 snapshot_test_delay_progress(SNAPTEST_DELETE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 old_blocks, blocks, max_bl=
ocks);
>> +#endif
>> =A0 =A0 =A0 i_size_write((inode), (loff_t)(blocks) << SNAPSHOT_BLOCK=
_SIZE_BITS);
>> =A0}
>>
>> diff --git a/fs/ext4/snapshot_debug.h b/fs/ext4/snapshot_debug.h
>> index e69de29..f893eb1 100644
>> --- a/fs/ext4/snapshot_debug.h
>> +++ b/fs/ext4/snapshot_debug.h
>> @@ -0,0 +1,105 @@
>> +/*
>> + * linux/fs/ext4/snapshot_debug.h
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
>> + * Ext4 snapshot debugging.
>> + */
>> +
>> +#ifndef _LINUX_EXT4_SNAPSHOT_DEBUG_H
>> +#define _LINUX_EXT4_SNAPSHOT_DEBUG_H
>> +
>> +#if defined(CONFIG_EXT4_FS_SNAPSHOT) && defined(CONFIG_EXT4_DEBUG)
>> +#include <linux/delay.h>
>> +
>> +#define SNAPSHOT_INDENT_MAX 4
>> +#define SNAPSHOT_INDENT_STR "\t\t\t\t"
>> +
>> +#define SNAPTEST_TAKE =A0 =A0 =A0 =A00
>> +#define SNAPTEST_DELETE =A0 =A0 =A01
>> +#define SNAPTEST_COW 2
>> +#define SNAPTEST_READ =A0 =A0 =A0 =A03
>> +#define SNAPTEST_BITMAP =A0 =A0 =A04
>> +#define SNAPSHOT_TESTS_NUM =A0 5
>> +
>> +extern const char *snapshot_indent;
>> +extern u8 snapshot_enable_debug;
>> +extern u16 snapshot_enable_test[SNAPSHOT_TESTS_NUM];
>> +extern u8 cow_cache_enabled;
>> +
>> +#define snapshot_test_delay(i) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0\
>> + =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (snapshot_enable_test[i]) =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep_interruptible(snaps=
hot_enable_test[i]); \
>> + =A0 =A0 } while (0)
>> +
>> +/*
>> + * Sleep 1ms every 'blocks_per_ms', amounting to the total test del=
ay
>> + * over 100% of progress (when 'to' reaches 'max').
>> + * snapshot_enable_test[i] (msec) is limited to 64K and max (blocks=
_count)
>> + * is likely much more than 64K, so 'blocks_per_ms' is likely non z=
ero.
>> + */
>
> Oh, here is a good place for explaining the purpose.
>
>> +#define snapshot_test_delay_progress(i, from, to, max) =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (snapshot_enable_test[i] && =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (max) > sn=
apshot_enable_test[i] && =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (from) <=3D=
 (to) && (to) <=3D (max)) { =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long blocks_per_m=
s =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_div((ma=
x), snapshot_enable_test[i]); \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long x =3D do_div=
((from), blocks_per_ms);\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long y =3D do_div=
((to), blocks_per_ms); =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (y > x) =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep_int=
erruptible(y - x); =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 } while (0)
>> +
>> +#define snapshot_debug_l(n, l, f, a...) =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((n) <=3D snapshot_enable_debug && =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (l) <=3D SNAPSHOT_INDENT_MAX) { =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "snapsho=
t: %s" f, =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snapshot_in=
dent - (l), =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0## =
a); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 } while (0)
>
> This can be done by tracepoints maybe ?

can you add a generic string arg to a tracepoint?

>
>> +
>> +#define snapshot_debug(n, f, a...) =A0 snapshot_debug_l(n, 0, f, ##=
 a)
>> +
>> +#define snapshot_debug_once(n, f, a...) =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>
> formating

what do you mean?

>
>> + =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 static bool __once; =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!__once) { =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 snapshot_debug(n, f, ## a)=
; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __once =3D true; =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 } while (0)
>> +
>> +extern void ext4_snapshot_create_debugfs_entry(struct dentry *debug=
fs_dir);
>> +extern void ext4_snapshot_remove_debugfs_entry(void);
>> +
>> +#else
>> +#define snapshot_enable_debug (0)
>> +#define snapshot_test_delay(i)
>> +#define snapshot_test_delay_progress(i, from, to, max)
>> +#define snapshot_debug(n, f, a...)
>> +#define snapshot_debug_l(n, l, f, a...)
>> +#define snapshot_debug_once(n, f, a...)
>> +#define ext4_snapshot_create_debugfs_entry(d)
>> +#define ext4_snapshot_remove_debugfs_entry()
>> +#endif
>> +
>> +
>> +/* debug levels */
>> +#define SNAP_ERR =A0 =A0 1 /* errors and summary */
>> +#define SNAP_WARN =A0 =A02 /* warnings */
>
> It seems to me that those two levels should be displayed no matter wh=
at
> via standard functions.

I agree.

>
>> +#define SNAP_INFO =A0 =A03 /* info */
>> +#define SNAP_DEBUG =A0 4 /* debug */
>
> And this two levels can be done in tracepoints.

I will look into it.

>
>> +#define SNAP_DUMP =A0 =A05 /* dump snapshot file */
>
> Via e2fsprogs debugfs maybe ?
>

certainly. I was not indenting to post to debug patch that uses this le=
vel.

>> +
>> +#endif =A0 =A0 =A0 /* _LINUX_EXT4_SNAPSHOT_DEBUG_H */
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
