From: Pavel Machek <pavel@suse.cz>
Subject: ext3 read only handling
Date: Thu, 25 Sep 2008 17:03:19 +0200
Message-ID: <20080925150319.GA4344@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: kernel list <linux-kernel@vger.kernel.org>, tytso@mit.edu,
	jack@suse.cz, sct@redhat.com, akpm@linux-foundation.org,
	adilger@sun.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756318AbYIYPCO@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Inserting read-only ext3 SD card into a machine and trying to mount
ext3 volume on it is very unnice :-(.

Is there easy way to "fix" -oro so that it does not write to the
media?

(Machine died after I played with that SD card a bit more, but I can't
easily reproduce that...)

								Pavel

Sep 25 11:51:38 amd kernel: mmcblk0: mmc0:0002 SD1GB 975872KiB (ro)
Sep 25 11:51:38 amd kernel:  mmcblk0: p1
Sep 25 11:51:47 amd kernel: JBD: Clearing recovery information on
journal
Sep 25 11:51:47 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:47 amd kernel: end_request: I/O error, dev mmcblk0,
sector 4017
Sep 25 11:51:47 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 486
Sep 25 11:51:47 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:48 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:48 amd kernel: end_request: I/O error, dev mmcblk0,
sector 129
Sep 25 11:51:48 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 0
Sep 25 11:51:48 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:48 amd kernel: end_request: I/O error, dev mmcblk0,
sector 137
Sep 25 11:51:48 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 1
Sep 25 11:51:48 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:48 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:48 amd kernel: end_request: I/O error, dev mmcblk0,
sector 161
Sep 25 11:51:48 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 4
Sep 25 11:51:48 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:49 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:49 amd kernel: end_request: I/O error, dev mmcblk0,
sector 3977
Sep 25 11:51:49 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 481
Sep 25 11:51:49 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:49 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:49 amd kernel: end_request: I/O error, dev mmcblk0,
sector 262305
Sep 25 11:51:49 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 32772
Sep 25 11:51:49 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:50 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:50 amd kernel: end_request: I/O error, dev mmcblk0,
sector 524417
Sep 25 11:51:50 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 65536
Sep 25 11:51:50 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:50 amd kernel: end_request: I/O error, dev mmcblk0,
sector 524425
Sep 25 11:51:50 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 65537
Sep 25 11:51:50 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:50 amd kernel: end_request: I/O error, dev mmcblk0,
sector 524433
Sep 25 11:51:50 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 65538
Sep 25 11:51:50 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:50 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:50 amd kernel: end_request: I/O error, dev mmcblk0,
sector 528249
Sep 25 11:51:50 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 66015
Sep 25 11:51:50 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:51 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:51 amd kernel: end_request: I/O error, dev mmcblk0,
sector 1048705
Sep 25 11:51:51 amd kernel: end_request: I/O error, dev mmcblk0,
sector 1048713
Sep 25 11:51:51 amd kernel: end_request: I/O error, dev mmcblk0,
sector 1048721
Sep 25 11:51:51 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:51 amd kernel: end_request: I/O error, dev mmcblk0,
sector 1052537
Sep 25 11:51:52 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:52 amd kernel: end_request: I/O error, dev mmcblk0,
sector 4017
Sep 25 11:51:52 amd kernel: kjournald starting.  Commit interval 5
seconds
Sep 25 11:51:52 amd kernel: ------------[ cut here ]------------
Sep 25 11:51:52 amd kernel: WARNING: at /data/l/linux/fs/buffer.c:1186
mark_buffer_dirty+0x57/0x70()
Sep 25 11:51:52 amd kernel: Modules linked in:
Sep 25 11:51:52 amd kernel: Pid: 16292, comm: mount Not tainted
2.6.27-rc6 #379
Sep 25 11:51:52 amd kernel:  [<c022ae8f>] warn_on_slowpath+0x5f/0x90
Sep 25 11:51:52 amd kernel:  [<c02a36c2>] __find_get_block+0x82/0x190
Sep 25 11:51:52 amd kernel:  [<c024a611>] __lock_acquire+0x181/0x930
Sep 25 11:51:52 amd kernel:  [<c024a611>] __lock_acquire+0x181/0x930
Sep 25 11:51:52 amd kernel:  [<c03006b7>]
journal_update_superblock+0x67/0xd0
Sep 25 11:51:52 amd kernel:  [<c02a3c97>] mark_buffer_dirty+0x57/0x70
Sep 25 11:51:52 amd kernel:  [<c03006bf>]
journal_update_superblock+0x6f/0xd0
Sep 25 11:51:52 amd kernel:  [<c0300b31>] journal_flush+0xa1/0x120
Sep 25 11:51:52 amd kernel:  [<c02f4a6c>]
ext3_mark_recovery_complete+0x2c/0x80
Sep 25 11:51:52 amd kernel:  [<c02f747e>]
ext3_fill_super+0x125e/0x1800
Sep 25 11:51:52 amd kernel:  [<c039089f>] snprintf+0x1f/0x30
Sep 25 11:51:52 amd kernel:  [<c02c0d00>] disk_name+0xb0/0xc0
Sep 25 11:51:52 amd kernel:  [<c0284304>] get_sb_bdev+0x104/0x130
Sep 25 11:51:52 amd kernel:  [<c026a299>] kstrdup+0x39/0x70
Sep 25 11:51:52 amd kernel:  [<c02f4810>] ext3_get_sb+0x20/0x30
Sep 25 11:51:52 amd kernel:  [<c02f6220>] ext3_fill_super+0x0/0x1800
Sep 25 11:51:52 amd kernel:  [<c0283e33>] vfs_kern_mount+0x43/0x90
Sep 25 11:51:52 amd kernel:  [<c0283edd>] do_kern_mount+0x3d/0xe0
Sep 25 11:51:52 amd kernel:  [<c0299f71>] do_new_mount+0x81/0xc0
Sep 25 11:51:52 amd kernel:  [<c029a127>] do_mount+0x177/0x1d0
Sep 25 11:51:52 amd kernel:  [<c0297de0>]
copy_mount_options+0x40/0x150
Sep 25 11:51:52 amd kernel:  [<c029a1f7>] sys_mount+0x77/0xc0
Sep 25 11:51:52 amd kernel:  [<c0203c3a>] syscall_call+0x7/0xb
Sep 25 11:51:52 amd kernel:  =======================
Sep 25 11:51:52 amd kernel: ---[ end trace c1e48b3b4f28cda2 ]---
Sep 25 11:51:52 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:52 amd kernel: end_request: I/O error, dev mmcblk0,
sector 4017
Sep 25 11:51:53 amd kernel: mmcblk0: error -110 transferring data
Sep 25 11:51:53 amd kernel: end_request: I/O error, dev mmcblk0,
sector 129
Sep 25 11:51:53 amd kernel: __ratelimit: 6 callbacks suppressed
Sep 25 11:51:53 amd kernel: Buffer I/O error on device mmcblk0p1,
logical block 0
Sep 25 11:51:53 amd kernel: lost page write due to I/O error on
mmcblk0p1
Sep 25 11:51:53 amd kernel: EXT3-fs: mounted filesystem with ordered
data mode.
Sep 25 11:52:04 amd kernel: mmc0: card 0002 removed

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
