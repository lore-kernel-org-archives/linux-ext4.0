From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: 2.6.33-rc6: ext4 triggers warning about high order allocations
Date: Sun, 7 Feb 2010 14:30:33 +0200
Message-ID: <20100207123032.GA3220@redhat.com>
References: <20100203060854.GA12489@redhat.com> <4B69AB60.5070609@redhat.com> <20100203175836.GA16907@redhat.com> <4B69CCE4.3000904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab0BGMdt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Feb 2010 07:33:49 -0500
Content-Disposition: inline
In-Reply-To: <4B69CCE4.3000904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 03, 2010 at 01:22:12PM -0600, Eric Sandeen wrote:
> Michael S. Tsirkin wrote:
> > On Wed, Feb 03, 2010 at 10:59:12AM -0600, Eric Sandeen wrote:
> >> Michael S. Tsirkin wrote:
> >>> Hi!
> >>> I got this warning at boot with 2.6.33-rc6:
> >>>
> >>> [   12.374168] ------------[ cut here ]------------
> >>> [   12.375798] WARNING: at mm/page_alloc.c:1813 __alloc_pages_nodemask+0x180/0x666()
> >>> [   12.377401] Hardware name: 2241B48
> >>> [   12.378984] Modules linked in: [last unloaded: scsi_wait_scan]
> >>> [   12.380593] Pid: 1, comm: init Not tainted 2.6.33-rc6-aa-nopat #50
> >>> [   12.382194] Call Trace:
> >>> [   12.383781]  [<ffffffff810b6b3e>] ? __alloc_pages_nodemask+0x180/0x666
> >>> [   12.385390]  [<ffffffff81041cda>] warn_slowpath_common+0x77/0xa4
> >>> [   12.386996]  [<ffffffff81041d16>] warn_slowpath_null+0xf/0x11
> >>> [   12.388577]  [<ffffffff810b6b3e>] __alloc_pages_nodemask+0x180/0x666
> >>> [   12.390168]  [<ffffffff81036a9b>] ? finish_task_switch+0x4b/0xb1
> >>> [   12.391758]  [<ffffffff810b7036>] __get_free_pages+0x12/0x4f
> >>> [   12.393354]  [<ffffffff810de892>] __kmalloc+0x42/0x116
> >>> [   12.394934]  [<ffffffff812405bf>] match_number+0x35/0x98
> >>> [   12.396493]  [<ffffffff8124064d>] match_int+0xb/0xd
> >>> [   12.398045]  [<ffffffff81169c8c>] parse_options+0x5fe/0x733
> >>> [   12.399594]  [<ffffffff811058c3>] ? __wait_on_buffer+0x1f/0x21
> >>> [   12.401157]  [<ffffffff8116a2dc>] ext4_fill_super+0x373/0x2070
> >> Are you mounting with any interesting options?
> >>
> >> -Eric
> > 
> > Hmm yes:
> > 
> > UUID=4670fcf0-09a8-4011-bf25-6e5e97f263c6 /                       ext4
> > relatime,errors=remount-ro,auto_da_alloc,commit=300,journal_ioprio=7
>                              ^^^^
> 
> it's the auto_da_alloc option, which optionally takes a =X argument.
> I think someone changed match_one() and broke it;

patch?

> auto_da_alloc is
> the default anyway, so you can just drop this for now.
> 
> -Eric


I have removed auto_da_alloc option, but still see a warning at boot:

[   11.281241] ------------[ cut here ]------------
[   11.282879] WARNING: at mm/page_alloc.c:1813 __alloc_pages_nodemask+0x180/0x666()
[   11.284526] Hardware name: 2241B48
[   11.286144] Modules linked in: [last unloaded: scsi_wait_scan]
[   11.287747] Pid: 1, comm: init Not tainted 2.6.33-rc7-mst #55
[   11.289308] Call Trace:
[   11.290907]  [<ffffffff810b6f4a>] ? __alloc_pages_nodemask+0x180/0x666
[   11.292488]  [<ffffffff8104200a>] warn_slowpath_common+0x77/0xa4
[   11.294075]  [<ffffffff81042046>] warn_slowpath_null+0xf/0x11
[   11.295627]  [<ffffffff810b6f4a>] __alloc_pages_nodemask+0x180/0x666
[   11.297226]  [<ffffffff81036d9b>] ? finish_task_switch+0x4b/0xb1
[   11.298806]  [<ffffffff810b7442>] __get_free_pages+0x12/0x4f
[   11.300366]  [<ffffffff810e0e7a>] __kmalloc+0x42/0x116
[   11.301938]  [<ffffffff81242cff>] match_number+0x35/0x98
[   11.303457]  [<ffffffff81242d8d>] match_int+0xb/0xd
[   11.304991]  [<ffffffff8116c290>] parse_options+0x5fe/0x733
[   11.306940]  [<ffffffff81107ea7>] ? __wait_on_buffer+0x1f/0x21
[   11.308434]  [<ffffffff8116c8e0>] ext4_fill_super+0x373/0x2070
[   11.309938]  [<ffffffff8124152a>] ? snprintf+0x59/0x5b
[   11.311397]  [<ffffffff815cd94b>] ? _raw_spin_unlock_irq+0x24/0x2f
[   11.312894]  [<ffffffff8110c9b6>] ? __blkdev_get+0x29e/0x35a
[   11.314332]  [<ffffffff815cd4d2>] ? __down_write+0xb/0xd
[   11.315804]  [<ffffffff810e8ef6>] get_sb_bdev+0x12a/0x175
[   11.317241]  [<ffffffff8116c56d>] ? ext4_fill_super+0x0/0x2070
[   11.319166]  [<ffffffff8116a183>] ext4_get_sb+0x13/0x15
[   11.320640]  [<ffffffff810e8add>] vfs_kern_mount+0x9d/0x158
[   11.322078]  [<ffffffff810e8bf5>] do_kern_mount+0x47/0xe7
[   11.323510]  [<ffffffff810fe3d7>] do_mount+0x780/0x7f9
[   11.324953]  [<ffffffff810b7442>] ? __get_free_pages+0x12/0x4f
[   11.326368]  [<ffffffff8111be24>] compat_sys_mount+0x1ee/0x227
[   11.327795]  [<ffffffff810e4b8c>] ? do_sys_open+0xf5/0x104
[   11.329186]  [<ffffffff8102b412>] ia32_sysret+0x0/0x5
[   11.330598] ---[ end trace 8395227ad9785fe1 ]---

my mount options:


/dev/sda8 on / type ext4 (rw,relatime,errors=remount-ro,commit=300,journal_ioprio=7)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/sda7 on /boot type ext3 (rw,relatime,errors=remount-ro)
/dev/sda9 on /home type ext4 (rw,relatime,errors=remount-ro,commit=300,journal_ioprio=7)
tmpfs on /dev/shm type tmpfs (rw)
/dev/sda1 on /mnt/ubuntu type ext3 (rw,relatime,errors=remount-ro)
/dev/sda6 on /mnt/ubuntu/home type ext3 (rw,relatime)
sysfs on /mnt/ubuntu/sys type sysfs (rw)
proc on /mnt/ubuntu/proc type proc (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
gvfs-fuse-daemon on /home/mst/.gvfs type fuse.gvfs-fuse-daemon (rw,nosuid,nodev,user=mst)

-- 
MST
