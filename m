From: Matthew Rahtz <mrahtz@rapitasystems.com>
Subject: Re: warning in ext4_journal_start_sb on filesystem freeze
Date: Sat, 22 Feb 2014 09:50:06 +0000 (GMT)
Message-ID: <622177618.727.1393062606061.JavaMail.zimbra@rapitasystems.com>
References: <217983071.143460.1385453196946.JavaMail.zimbra@rapitasystems.com> <1697998867.143517.1385454051031.JavaMail.zimbra@rapitasystems.com> <20131126125826.GA4503@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rapitasystems.com ([81.149.227.87]:41430 "EHLO
	mail.rapitasystems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaBVJuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Feb 2014 04:50:13 -0500
In-Reply-To: <20131126125826.GA4503@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for your help Jan,

A few months later, we've noticed the issue is actually still there. Us=
ing 3.11.0-17-generic on Ubuntu 12.04, we=E2=80=99re seeing this in the=
 kernel logs:

[29243.606215] WARNING: CPU: 0 PID: 1785 at /build/buildd/linux-lts-sau=
cy-3.11.0/fs/ext4/ext4_jbd2.c:48 ext4_journal_check_start+0x83/0x90()

Having a look at the Ubuntu source package for that version, it definit=
ely does include commit 03d95eb2f2578083a3f6286262e1cb5d88a00c02, and t=
he line generating the warning is still:

WARN_ON(sb->s_writers.frozen =3D=3D SB_FREEZE_COMPLETE);

Are there any other obvious possibilities for what may be causing this?=
 There seem to be some users of Oracle Linux experiencing similar probl=
ems at https://community.oracle.com/thread/2617418, which was apparentl=
y fixed in Oracle's kernel version '3.8.13-26.el6uek'. Any word on when=
 this might be integrated into the official kernel?

=46ull call trace included below.

Thanks again!
Matthew

[29243.606212] ------------[ cut here ]------------
[29243.606215] WARNING: CPU: 0 PID: 1785 at /build/buildd/linux-lts-sau=
cy-3.11.0/fs/ext4/ext4_jbd2.c:48 ext4_journal_check_start+0x83/0x90()
[29243.606216] Modules linked in: parport_pc ppdev nfsd nfs_acl auth_rp=
cgss nfs fscache lockd sunrpc ext2 cirrus ttm drm_kms_helper drm sysimg=
blt psmouse i2c_piix4 virtio_balloon sysfillrect mac_hid serio_raw sysc=
opyarea virtio_console lp parport floppy
[29243.606227] CPU: 0 PID: 1785 Comm: nfsd Tainted: G        W    3.11.=
0-17-generic #31~precise1-Ubuntu
[29243.606228] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[29243.606228]  0000000000000030 ffff8801162f3b08 ffffffff8173c72d 0000=
000000000007
[29243.606230]  0000000000000000 ffff8801162f3b48 ffffffff8106540c 0000=
000000000000
[29243.606232]  ffff880114892800 0000000000000007 0000000000000068 0000=
000000000000
[29243.606235] Call Trace:
[29243.606237]  [<ffffffff8173c72d>] dump_stack+0x46/0x58
[29243.606239]  [<ffffffff8106540c>] warn_slowpath_common+0x8c/0xc0
[29243.606241]  [<ffffffff8106545a>] warn_slowpath_null+0x1a/0x20
[29243.606244]  [<ffffffff8127ebb3>] ext4_journal_check_start+0x83/0x90
[29243.606246]  [<ffffffff8127ec35>] __ext4_journal_start_sb+0x45/0x100
[29243.606249]  [<ffffffff81258a03>] ? ext4_dirty_inode+0x33/0x70
[29243.606251]  [<ffffffff81258a03>] ext4_dirty_inode+0x33/0x70
[29243.606254]  [<ffffffff811de348>] __mark_inode_dirty+0x48/0x350
[29243.606256]  [<ffffffff81256b53>] ext4_setattr+0x1b3/0x5b0
[29243.606259]  [<ffffffff811d0903>] notify_change+0x1d3/0x390
[29243.606263]  [<ffffffffa01c7fe2>] nfsd_setattr+0x232/0x2a0 [nfsd]
[29243.606267]  [<ffffffffa01d00f6>] nfsd3_proc_setattr+0x76/0xc0 [nfsd=
]
[29243.606271]  [<ffffffffa01c0d85>] nfsd_dispatch+0xe5/0x230 [nfsd]
[29243.606283]  [<ffffffffa0128465>] svc_process_common+0x345/0x680 [su=
nrpc]
[29243.606289]  [<ffffffffa0128af3>] svc_process+0x103/0x160 [sunrpc]
[29243.606293]  [<ffffffffa01c08df>] nfsd+0xbf/0x130 [nfsd]
[29243.606297]  [<ffffffffa01c0820>] ? nfsd_destroy+0x80/0x80 [nfsd]
[29243.606299]  [<ffffffff81089170>] kthread+0xc0/0xd0
[29243.606302]  [<ffffffff810890b0>] ? flush_kthread_worker+0xb0/0xb0
[29243.606304]  [<ffffffff8175122c>] ret_from_fork+0x7c/0xb0
[29243.606307]  [<ffffffff810890b0>] ? flush_kthread_worker+0xb0/0xb0
[29243.606308] ---[ end trace e9d4726f92c62d43 ]---

----- Original Message -----
=46rom: "Jan Kara" <jack@suse.cz>
To: "Matthew Rahtz" <mrahtz@rapitasystems.com>
Cc: linux-ext4@vger.kernel.org
Sent: Tuesday, 26 November, 2013 12:58:26 PM
Subject: Re: warning in ext4_journal_start_sb on filesystem freeze

  Hello,

On Tue 26-11-13 08:20:51, Matthew Rahtz wrote:
> We're using qemu's guest agent daemon, qemu-ga, to freeze ext4
> filesystems in guest virtual machines before taking an LVM snapshot o=
f
> the disk volume in the host. However, in the guests' dmesg, we're
> consistently seeing warnings like:=20
>=20
> [1246478.632936] WARNING: at /build/buildd/linux-lts-raring-3.8.0/fs/=
ext4/super.c:339 ext4_journal_start_sb+0x159/0x160()=20
>=20
> Looking at the source at
> https://github.com/torvalds/linux/blob/v3.8/fs/ext4/super.c#L339, thi=
s
> warning seems to be generated if the function is reached despite the
> filesystem being marked as frozen:
>=20
> WARN_ON(sb->s_writers.frozen =3D=3D SB_FREEZE_COMPLETE);
>=20
> In 3.12, this has been moved to
> https://github.com/torvalds/linux/blob/v3.12/fs/ext4/ext4_jbd2.c#L48.
>=20
> Is this something we should be concerned about? The process that seem=
s to
> be responsible for triggering it is mysqld, so we're concerned the
> databases in our snapshots have a higher possibility of being corrupt=
=2E
> (Taking online snapshots of databases like this is always risky, of
> course, but this just makes us a little more nervous :) ) Full kernel
> warning is attached below.
  Yes, it's a bug in 3.8 kernel which got fixed by commit
03d95eb2f2578083a3f6286262e1cb5d88a00c02 (merged in 3.10). Looking into=
 the
code there's really a chance the filesystem will be inconsistent becaus=
e of
that bug so you might be better off updating to a kernel which has this=
 bug
fixed if you rely on the snapshots heavily.

								Honza

> [1246478.632930] ------------[ cut here ]------------
> [1246478.632936] WARNING: at /build/buildd/linux-lts-raring-3.8.0/fs/=
ext4/super.c:339 ext4_journal_start_sb+0x159/0x160()
> [1246478.632938] Hardware name: Bochs
> [1246478.632939] Modules linked in: cirrus(F) ttm(F) drm_kms_helper(F=
) drm(F) sysimgblt(F) psmouse(F) sysfillrect(F) serio_raw(F) syscopyare=
a(F) microcode(F) virtio_console(F) lp(F) virtio_balloon(F) mac_hid(F) =
i2c_piix4(F) ext2(F) parport(F) floppy(F) e1000(F)
> [1246478.632973] Pid: 2856, comm: mysqld Tainted: GF       W    3.8.0=
-33-generic #48~precise1-Ubuntu
> [1246478.632975] Call Trace:
> [1246478.632981]  [<ffffffff81059b6f>] warn_slowpath_common+0x7f/0xc0
> [1246478.632985]  [<ffffffff81059bca>] warn_slowpath_null+0x1a/0x20
> [1246478.632989]  [<ffffffff8125eb59>] ext4_journal_start_sb+0x159/0x=
160
> [1246478.632993]  [<ffffffff8123f1c8>] ? _ext4_get_block+0x138/0x170
> [1246478.632997]  [<ffffffff8123f1c8>] _ext4_get_block+0x138/0x170
> [1246478.633002]  [<ffffffff8104e070>] ? get_user_pages_fast+0xe0/0x1=
a0
> [1246478.633006]  [<ffffffff8123f263>] ext4_get_block_write+0x13/0x20
> [1246478.633009]  [<ffffffff811d6d3a>] get_more_blocks+0x6a/0xa0
> [1246478.633013]  [<ffffffff811d7a7e>] do_direct_IO+0x4be/0x1530
> [1246478.633018]  [<ffffffff8107f9ab>] ? bit_waitqueue+0x1b/0xc0
> [1246478.633022]  [<ffffffff81186221>] ? kmem_cache_alloc+0x31/0x140
> [1246478.633026]  [<ffffffff811d8f22>] do_blockdev_direct_IO+0x432/0x=
13e0
> [1246478.633030]  [<ffffffff8123f250>] ? noalloc_get_block_write+0x30=
/0x30
> [1246478.633035]  [<ffffffff811d9f25>] __blockdev_direct_IO+0x55/0x60
> [1246478.633039]  [<ffffffff8123f250>] ? noalloc_get_block_write+0x30=
/0x30
> [1246478.633042]  [<ffffffff8123ab30>] ? ext4_journalled_invalidatepa=
ge+0x30/0x30
> [1246478.633046]  [<ffffffff8123bcd0>] ext4_ext_direct_IO+0x130/0x250
> [1246478.633050]  [<ffffffff8123f250>] ? noalloc_get_block_write+0x30=
/0x30
> [1246478.633053]  [<ffffffff8123ab30>] ? ext4_journalled_invalidatepa=
ge+0x30/0x30
> [1246478.633057]  [<ffffffff8123c1ad>] ext4_direct_IO+0x1ad/0x230
> [1246478.633061]  [<ffffffff8108e3ca>] ? finish_task_switch+0x4a/0xf0
> [1246478.633065]  [<ffffffff811368d6>] generic_file_direct_write+0xc6=
/0x180
> [1246478.633068]  [<ffffffff81136c6d>] __generic_file_aio_write+0x2dd=
/0x3b0
> [1246478.633072]  [<ffffffff816e5848>] ext4_file_dio_write+0x243/0x32=
0
> [1246478.633076]  [<ffffffff810b81b2>] ? unqueue_me+0x52/0x80
> [1246478.633079]  [<ffffffff81236ed8>] ext4_file_write+0xc8/0xe0
> [1246478.633084]  [<ffffffff8119b333>] do_sync_write+0xa3/0xe0
> [1246478.633089]  [<ffffffff8119b9d3>] vfs_write+0xb3/0x180
> [1246478.633093]  [<ffffffff8119be9a>] sys_pwrite64+0x9a/0xa0
> [1246478.633097]  [<ffffffff816fd15d>] system_call_fastpath+0x1a/0x1f
> [1246478.633099] ---[ end trace f37019187d44de90 ]---
> Please Note: Rapita Systems has a new address and telephone number.
> Telephone: +44 1904 413945
> Address: Rapita Systems Ltd, Atlas House,
>           Osbaldwick Link Road, YORK, YO10 3JB
>           United Kingdom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
Please Note: Rapita Systems has a new address and telephone number.
Telephone: +44 1904 413945
Address: Rapita Systems Ltd, Atlas House,
          Osbaldwick Link Road, YORK, YO10 3JB
          United Kingdom
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
