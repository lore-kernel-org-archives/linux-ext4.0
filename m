From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: warning in ext4_journal_start_sb on filesystem freeze
Date: Mon, 24 Feb 2014 10:55:25 +0100
Message-ID: <20140224095525.GA20532@quack.suse.cz>
References: <217983071.143460.1385453196946.JavaMail.zimbra@rapitasystems.com>
 <1697998867.143517.1385454051031.JavaMail.zimbra@rapitasystems.com>
 <20131126125826.GA4503@quack.suse.cz>
 <622177618.727.1393062606061.JavaMail.zimbra@rapitasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
To: Matthew Rahtz <mrahtz-lFL+a/sBLVi/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <622177618.727.1393062606061.JavaMail.zimbra-lFL+a/sBLVi/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat 22-02-14 09:50:06, Matthew Rahtz wrote:
> Thanks for your help Jan,
>=20
> A few months later, we've noticed the issue is actually still there.
> Using 3.11.0-17-generic on Ubuntu 12.04, we=E2=80=99re seeing this in=
 the kernel
> logs:
>=20
> [29243.606215] WARNING: CPU: 0 PID: 1785 at
> /build/buildd/linux-lts-saucy-3.11.0/fs/ext4/ext4_jbd2.c:48
> ext4_journal_check_start+0x83/0x90()
>=20
> Having a look at the Ubuntu source package for that version, it
> definitely does include commit 03d95eb2f2578083a3f6286262e1cb5d88a00c=
02,
> and the line generating the warning is still:
>=20
> WARN_ON(sb->s_writers.frozen =3D=3D SB_FREEZE_COMPLETE);
>=20
> Are there any other obvious possibilities for what may be causing thi=
s?
> There seem to be some users of Oracle Linux experiencing similar prob=
lems
> at https://community.oracle.com/thread/2617418, which was apparently
> fixed in Oracle's kernel version '3.8.13-26.el6uek'. Any word on when
> this might be integrated into the official kernel?
>=20
> Full call trace included below.
  Looking at the trace below, now the problem seems to be in the NFS se=
rver
code. NFS should get protection against the filesystem being frozen (or
remounted read-only for that matter) via mnt_want_write() before callin=
g
into notify_change() (actually before calling fh_lock() because of lock
ordering).  Similarly to what we do e.g. in fchownat(). Bruce?

								Honza

> [29243.606212] ------------[ cut here ]------------
> [29243.606215] WARNING: CPU: 0 PID: 1785 at /build/buildd/linux-lts-s=
aucy-3.11.0/fs/ext4/ext4_jbd2.c:48 ext4_journal_check_start+0x83/0x90()
> [29243.606216] Modules linked in: parport_pc ppdev nfsd nfs_acl auth_=
rpcgss nfs fscache lockd sunrpc ext2 cirrus ttm drm_kms_helper drm sysi=
mgblt psmouse i2c_piix4 virtio_balloon sysfillrect mac_hid serio_raw sy=
scopyarea virtio_console lp parport floppy
> [29243.606227] CPU: 0 PID: 1785 Comm: nfsd Tainted: G        W    3.1=
1.0-17-generic #31~precise1-Ubuntu
> [29243.606228] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [29243.606228]  0000000000000030 ffff8801162f3b08 ffffffff8173c72d 00=
00000000000007
> [29243.606230]  0000000000000000 ffff8801162f3b48 ffffffff8106540c 00=
00000000000000
> [29243.606232]  ffff880114892800 0000000000000007 0000000000000068 00=
00000000000000
> [29243.606235] Call Trace:
> [29243.606237]  [<ffffffff8173c72d>] dump_stack+0x46/0x58
> [29243.606239]  [<ffffffff8106540c>] warn_slowpath_common+0x8c/0xc0
> [29243.606241]  [<ffffffff8106545a>] warn_slowpath_null+0x1a/0x20
> [29243.606244]  [<ffffffff8127ebb3>] ext4_journal_check_start+0x83/0x=
90
> [29243.606246]  [<ffffffff8127ec35>] __ext4_journal_start_sb+0x45/0x1=
00
> [29243.606249]  [<ffffffff81258a03>] ? ext4_dirty_inode+0x33/0x70
> [29243.606251]  [<ffffffff81258a03>] ext4_dirty_inode+0x33/0x70
> [29243.606254]  [<ffffffff811de348>] __mark_inode_dirty+0x48/0x350
> [29243.606256]  [<ffffffff81256b53>] ext4_setattr+0x1b3/0x5b0
> [29243.606259]  [<ffffffff811d0903>] notify_change+0x1d3/0x390
> [29243.606263]  [<ffffffffa01c7fe2>] nfsd_setattr+0x232/0x2a0 [nfsd]
> [29243.606267]  [<ffffffffa01d00f6>] nfsd3_proc_setattr+0x76/0xc0 [nf=
sd]
> [29243.606271]  [<ffffffffa01c0d85>] nfsd_dispatch+0xe5/0x230 [nfsd]
> [29243.606283]  [<ffffffffa0128465>] svc_process_common+0x345/0x680 [=
sunrpc]
> [29243.606289]  [<ffffffffa0128af3>] svc_process+0x103/0x160 [sunrpc]
> [29243.606293]  [<ffffffffa01c08df>] nfsd+0xbf/0x130 [nfsd]
> [29243.606297]  [<ffffffffa01c0820>] ? nfsd_destroy+0x80/0x80 [nfsd]
> [29243.606299]  [<ffffffff81089170>] kthread+0xc0/0xd0
> [29243.606302]  [<ffffffff810890b0>] ? flush_kthread_worker+0xb0/0xb0
> [29243.606304]  [<ffffffff8175122c>] ret_from_fork+0x7c/0xb0
> [29243.606307]  [<ffffffff810890b0>] ? flush_kthread_worker+0xb0/0xb0
> [29243.606308] ---[ end trace e9d4726f92c62d43 ]---
--=20
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
