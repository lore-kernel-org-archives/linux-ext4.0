From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: next-20090310: ext4 hangs
Date: Tue, 10 Mar 2009 15:17:51 +0300
Message-ID: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

It is similar to http://lkml.org/lkml/2009/2/6/304,
http://bugzilla.kernel.org/show_bug.cgi?id=12579


I run dbench on ext4 on loop on ext3 on sparc.
The kernel is 2.6.29-rc7-next-20090310
e2fsprogs -1.41.4

ioctl32(mkfs.ext4:1668): Unknown cmd fd(3) cmd(40041272){t:12;sz:4}
arg(ffb2ce60) on /testfs
ioctl32(mkfs.ext4:1668): Unknown cmd fd(3) cmd(20001260){t:12;sz:0}
arg(ffb2ce6c) on /testfs
ioctl32(mkfs.ext4:1668): Unknown cmd fd(3) cmd(401c0204){t:02;sz:28}
arg(ffb2ce44) on /testfs
ioctl32(mkfs.ext4:1668): Unknown cmd fd(3) cmd(20001268){t:12;sz:0}
arg(ffb2d564) on /testfs
ioctl32(mkfs.ext4:1668): Unknown cmd fd(3) cmd(2000125e){t:12;sz:0}
arg(ffb2ce6c) on /testfs
EXT4-fs: barriers enabled
EXT4 FS on loop0, internal journal on loop0:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem loop0 with ordered data mode
kjournald2 starting: pid 1672, dev loop0:8, commit interval 5 seconds
JBD: barrier-based sync failed on loop0:8 - disabling barriers
INFO: task kjournald2:1672 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald2    D 0000000000557a0c     0  1672      2
Call Trace:
 [0000000000768bcc] schedule+0x18/0x40
 [0000000000557a0c] jbd2_journal_commit_transaction+0x208/0x1718
 [000000000055d758] kjournald2+0x14c/0x318
 [0000000000465d34] kthread+0x48/0x7c
 [000000000042b364] kernel_thread+0x3c/0x54
 [0000000000465c88] kthreadd+0xc8/0x12c
INFO: lockdep is turned off.
INFO: task dbench:1674 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
dbench        D 000000000055716c     0  1674   1673
Call Trace:
 [0000000000768bcc] schedule+0x18/0x40
 [000000000055716c] start_this_handle+0x374/0x508
 [0000000000557500] jbd2_journal_start+0xbc/0x11c
 [000000000053a438] ext4_journal_start_sb+0x5c/0x84
 [000000000052a9b8] ext4_dirty_inode+0xd4/0xf0
 [00000000004d1a14] __mark_inode_dirty+0x2c/0x188
 [00000000004c7714] touch_atime+0x160/0x178
 [00000000004c2a3c] vfs_readdir+0x88/0xb0
 [00000000004eab90] compat_sys_getdents+0x3c/0x8c
 [0000000000406154] linux_sparc_syscall32+0x34/0x40
