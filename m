From: Dave Chinner <david@fromorbit.com>
Subject: [4.7-rc4] WARNING: CPU: 10 PID: 3359 at fs/inode.c:280
 drop_nlink+0x3e/0x50
Date: Tue, 5 Jul 2016 09:46:33 +1000
Message-ID: <20160704234633.GE27480@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30688 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbcGDXqg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jul 2016 19:46:36 -0400
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>)
	id 1bKDZR-0006y5-Mi
	for linux-ext4@vger.kernel.org; Tue, 05 Jul 2016 09:46:33 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

I just got this warning on boot from a test VM running an ext3
root filesystem:

[   14.874951] ------------[ cut here ]------------
[   14.876447] WARNING: CPU: 10 PID: 3359 at fs/inode.c:280 drop_nlink+0x3e/0x50
[   14.878520] Modules linked in:
[   14.880065] CPU: 10 PID: 3359 Comm: mv Not tainted 4.7.0-rc4-dgc+ #821
[   14.883062] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[   14.886648]  0000000000000000 ffff8800bad63c90 ffffffff817f1321 0000000000000000
[   14.888942]  0000000000000000 ffff8800bad63cd0 ffffffff810b3531 000001183750906c
[   14.891613]  ffff8800bb3095b0 ffff8800bad63d48 ffff88033750906c 0000000000000000
[   14.893635] Call Trace:
[   14.894096]  [<ffffffff817f1321>] dump_stack+0x63/0x82
[   14.895387]  [<ffffffff810b3531>] __warn+0xd1/0xf0
[   14.896709]  [<ffffffff810b361d>] warn_slowpath_null+0x1d/0x20
[   14.898421]  [<ffffffff8121339e>] drop_nlink+0x3e/0x50
[   14.899737]  [<ffffffff812d7d7b>] ext4_dec_count.isra.26+0x1b/0x30
[   14.901360]  [<ffffffff812dd8a2>] ext4_rename+0x4d2/0x880
[   14.903025]  [<ffffffff8177bde8>] ? security_capable+0x48/0x60
[   14.904524]  [<ffffffff812ddc6d>] ext4_rename2+0x1d/0x30
[   14.905833]  [<ffffffff8120676d>] vfs_rename+0x5fd/0x900
[   14.907163]  [<ffffffff81209738>] SyS_rename+0x398/0x3b0
[   14.908496]  [<ffffffff81e3c2f2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[   14.910251] ---[ end trace b59a7c09fe84eaba ]---

It's from the root device:

16 0 8:1 / / rw,relatime shared:1 - ext3 /dev/root rw,errors=remount-ro,data=ordered

It happened during boot after I had to forcible terminate the VM
from the host due to it becoming unresponsive while testing XFS code
changes on a test filesystem. The mount messages were:

[    3.187990] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
[    3.191331] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    3.193546] EXT4-fs (sda1): write access will be enabled during recovery
[    3.448499] EXT4-fs (sda1): orphan cleanup on readonly fs
[    3.450334] EXT4-fs (sda1): 1 orphan inode deleted
[    3.451762] EXT4-fs (sda1): recovery complete
[    3.462121] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)

It's a 10GB fs, 85% full. I can't reproduce it and I've got no more
information in the logs about the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
