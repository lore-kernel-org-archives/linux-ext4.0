From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: ext4: journal has aborted
Date: Fri, 4 Jul 2014 16:48:01 -0400
Message-ID: <20140704204801.GA3554@wallace>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile>
 <20140701084206.GG9743@birch.djwong.org>
 <53B2A47F.90903@samsung.com>
 <20140701155812.GD2775@thunk.org>
 <20140701163646.GA3126@wallace>
 <20140702121752.37e1f181@archvile>
 <CAFnufp0Fm8F=qu87R5LiOAunc_2axk4+g9J4euOjaCcNak0MnQ@mail.gmail.com>
 <20140703171434.GA15790@wallace>
 <20140703231748.GA5320@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>,
	Matteo Croce <technoboy85@gmail.com>,
	David Jander <david@protonic.nl>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59952 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaGDUsF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 16:48:05 -0400
Received: by mail-qc0-f180.google.com with SMTP id r5so1846930qcx.11
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jul 2014 13:48:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140703231748.GA5320@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> On Thu, Jul 03, 2014 at 01:14:34PM -0400, Eric Whitney wrote:
> > 
> > FWIW, I've also been able to reproduce that failure scenario on an
> > x86_64 KVM with raw virtio disks alone.  It's just a lot harder to
> > get there with that configuration - many more trials required.
> 
> What configuration are you using when you see the failure using x86_64
> KVM with raw virtio?  Is this using kvm-xfstests, or some other setup?
> And which file system is getting corrupted?
> 
> Because with kvm-xfstests the root file system is a read-only
> snapshot, and the "mmcblk0p3" device which you show before is clearly
> not the virtio device....
> 

I'd meant the x86_64 note (paragraph beginning with FWIW) as an aside, and that
regrettably caused confusion.  Here's a more formal report, this time largely
limited to an x86_64 case where eMMC is not involved.

x86_64 KVM case:

Base distro installed - Ubuntu 13.10
Kernel version - mainline 3.15-rc3
e2fsprogs - master branch, bb9cca2ca9
xfstests - master branch, 45d1fac130
xfsprogs - master branch, 03e956b252
xfstests-bld - master branch, 723c23e1b2 (about a year old)

(e2fsprogs, xfstests, and xfsprogs are relatively recent - 1 to 2 months old,
and latest as of the availability of 3.15-rc1.)

The test scenario involves running xfstest generic/068 using the runtests.sh
script from xfstests-bld within a KVM constructed with libvirt tools and where
all test components were built and installed by hand.  (kvm-xfstests was not
used here.)

The virtual machine running the test used a raw virtio disk for the root (vda)
and for the test filesystem (vdc).  (Two other virtio disks were also
attached but not used for this test - vdb and vdd.)

vda contained a vanilla 4k ext4 filesystem as provided by the distro.  vdc
contained a 4k ext4 filesystem mounted with the data=journal and
block_validity mount options, newly created and mounted before each attempt
to execute the test.

The failure sequence:

1) running generic/068 on vdc forces a BUG -

[ 1976.238967] kernel BUG at fs/buffer.c:3017!
[ 1976.239070] invalid opcode: 0000 [#1] SMP
[ 1976.239150] Modules linked in: kvm_intel kvm psmouse microcode i2c_piix4 serio_raw virtio_balloon
[ 1976.239286] CPU: 0 PID: 11705 Comm: xfs_io Not tainted 3.15.0-rc3-emmc+ #1
[ 1976.239380] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1976.239472] task: ffff88007624a110 ti: ffff8800768da000 task.ti: ffff8800768da000
[ 1976.239568] RIP: 0010:[<ffffffff811d849c>]  [<ffffffff811d849c>] _submit_bh+0x18c/0x210
[ 1976.239682] RSP: 0018:ffff8800768dbd38  EFLAGS: 00010246
[ 1976.239763] RAX: 000000000022c005 RBX: ffff88006e3e3e38 RCX: 0000000000000000
[ 1976.242063] RDX: 0000000000000000 RSI: ffff88006e3e3e38 RDI: 0000000000000411
[ 1976.242759] RBP: ffff8800768dbd58 R08: 0000000000000000 R09: 0000000000000000
[ 1976.242759] R10: 00000000000360b0 R11: 0000000225c17d03 R12: ffff88006e3e3e38
[ 1976.242759] R13: ffff8800768dbe14 R14: ffff880067648800 R15: ffff88006e023410
[ 1976.242759] FS:  00007f2e03b85740(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[ 1976.242759] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1976.242759] CR2: 000000000061da00 CR3: 0000000076a68000 CR4: 00000000000006f0
[ 1976.242759] Stack:
[ 1976.242759]  ffff88006e3e3e38 0000000000000411 ffff8800768dbe14 ffff880067648800
[ 1976.242759]  ffff8800768dbd78 ffffffff811d8f71 0000000000000001 ffff880067648b00
[ 1976.242759]  ffff8800768dbde0 ffffffff8129a67d 0000000091827364 ffff8800768dbd90
[ 1976.242759] Call Trace:
[ 1976.242759]  [<ffffffff811d8f71>] write_dirty_buffer+0x51/0x70
[ 1976.242759]  [<ffffffff8129a67d>] __flush_batch+0x4d/0xa0
[ 1976.242759]  [<ffffffff8129ac5c>] jbd2_log_do_checkpoint+0x1dc/0x480
[ 1976.242759]  [<ffffffff8129f574>] jbd2_journal_flush+0x94/0x180
[ 1976.242759]  [<ffffffff8126277e>] ext4_freeze+0x3e/0x80
[ 1976.242759]  [<ffffffff811a6a88>] freeze_super+0xb8/0x130
[ 1976.242759]  [<ffffffff811b7d3e>] do_vfs_ioctl+0x2ce/0x520
[ 1976.242759]  [<ffffffff816d3689>] ? retint_swapgs+0xe/0x13
[ 1976.242759]  [<ffffffff810a09ed>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[ 1976.242759]  [<ffffffff811b8011>] SyS_ioctl+0x81/0xa0
[ 1976.242759]  [<ffffffff816dbf92>] system_call_fastpath+0x16/0x1b
[ 1976.242759] Code: 5d 41 5e 5d c3 66 2e 0f 1f 84 00 00 00 00 00 40 f6 c7 01 0f 84 e3 fe ff ff f0 41 80 64 24 01 f7 e9 d7 fe ff ff 0f 0b 0f 0b 0f 0b <0f> 0b 0f 0b 48 8b 53 78 c1 e0 09 41 f6 c5 01 89 43 28\
 89 42 08
[ 1976.242759] RIP  [<ffffffff811d849c>] _submit_bh+0x18c/0x210
[ 1976.242759]  RSP <ffff8800768dbd38>
[ 1976.268124] ---[ end trace c0ad2d4fabce4179 ]---

(Note that this snippet was extracted from the kernel log - /var/log/kern.log
on the root filesystem, and was therefore written successfully.)

2) Components of the test are then left in the D state (fsstress blocked on
wchan sync_inodes_sb and rm on vfs_unlink according to ps), and the test's
controlling shell is unresponsive.

3) Rebooting the test system then leads to a hang as the system is shutting
down - unresponsive console, shutdown does not make progress.  (Nothing new
here.)

4) Resetting the virtual machine leads to a reboot, which in most (but not
all) cases results in a read-only root filesystem.  (This is where the
filesystem damage is that I mentioned.)

>From the dmesg log after reboot (since the kernel log can't be written once
the root filesystem is read only) -

[    1.030238] EXT4-fs (vda1): INFO: recovery required on readonly filesystem
[    1.031162] EXT4-fs (vda1): write access will be enabled during recovery
[    1.432329] tsc: Refined TSC clocksource calibration: 3000.110 MHz
[    1.472223] EXT4-fs (vda1): recovery complete
[    1.477099] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.598232] random: init urandom read with 38 bits of entropy available
[    2.079563] Adding 1046524k swap on /dev/vda5.  Priority:-1 extents:1 across:1046524k FS
[    2.305267] systemd-udevd[263]: starting version 204
[    2.440193] Switched to clocksource tsc
[    2.441306] EXT4-fs (vda1): re-mounted. Opts: errors=remount-ro
[    2.626895] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    2.729328] audit: type=1400 audit(1404499589.548:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=314 comm="apparmor_parser"
[    2.729338] audit: type=1400 audit(1404499589.548:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=314 comm="apparmor_parser"
[    2.729342] audit: type=1400 audit(1404499589.548:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=314 comm="apparmor_parser"
[    2.729803] audit: type=1400 audit(1404499589.548:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=314 comm="apparmor_parser"
[    2.729810] audit: type=1400 audit(1404499589.548:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=314 comm="apparmor_parser"
[    2.729997] audit: type=1400 audit(1404499589.548:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=314 comm="apparmor_parser"
[    2.853872] microcode: CPU0 sig=0x623, pf=0x0, revision=0x1
[    2.858650] microcode: CPU1 sig=0x623, pf=0x0, revision=0x1
[    2.871491] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.780154] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    4.012541] init: failsafe main process (628) killed by TERM signal
[    4.300987] audit: type=1400 audit(1404499591.120:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=749 comm="apparmor_parser"
[    4.300997] audit: type=1400 audit(1404499591.120:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=749 comm="apparmor_parser"
[    4.301003] audit: type=1400 audit(1404499591.120:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=749 comm="apparmor_parser"
[    4.361772] EXT4-fs error (device vda1): ext4_mb_generate_buddy:756: group 42, 2591 clusters in bitmap, 2592 in gd; block bitmap corrupt.
[    4.361908] Aborting journal on device vda1-8.
[    4.362198] EXT4-fs (vda1): Remounting filesystem read-only

(Note that this snippet is complete from the first indication of successful
recovery of the root filesystem on reboot down to the apparent subsequent
discovery of block bitmap corruption and journal abort.)

5)  A second reboot attempt forces fsck to run and successfully recover the
root filesystem, whereupon the test system resumes normal operation.  (I've
never observed a failed recovery attempt at this step.)

This same sequence occurs in 3.14 (and has over several past releases) with the
exception of the block bitmap corruption indication and automated fsck
recovery on reboot here at the end.  That appears to be new in 3.15 (and at
least as early there as -rc3).

It's about an order of magnitude harder for me to reproduce this on my
x86_64 KVM as on my Pandaboard test system.  It requires 100-200 generic/068
trials to trigger the failure on x86_64 as opposed to roughly 10 on the
Pandaboard (this is a measure of the relative difficulty in triggering the
generic/068 failure only - the block bitmap corruption then generally but not
always occurs).  So far, I've not been able to reproduce the failure on 3.14 on
either test system.

To be clear, it's not that I think the generic/068 failure is directly
related to the block bitmap corruption on the root filesystem - it simply
appears to be a (really awkward) way to trigger that behavior.

Eric






