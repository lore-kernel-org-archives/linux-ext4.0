From: Nathaniel W Filardo <nwf@cs.jhu.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Thu, 1 May 2014 12:25:03 -0400
Message-ID: <20140501162503.GL5136@gradx.cs.jhu.edu>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mit9XoPEfICDqq/V"
Cc: linux-ext4@vger.kernel.org, admins@acm.jhu.edu
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blaze.cs.jhu.edu ([128.220.13.50]:58575 "EHLO blaze.cs.jhu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaEAQZH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 May 2014 12:25:07 -0400
Content-Disposition: inline
In-Reply-To: <20140423143642.GA29925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Mit9XoPEfICDqq/V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here's another kernel report, this time from /dev/sda1, which is a QEMU-IDE
view of a local LVM volume and is only 4060864 blocks big, so it falls into
neither the "Ceph's fault" nor "8TB is special" bins:

[922646.672586] EXT4-fs error (device sda1): ext4_mb_generate_buddy:756: group 17, 24652 clusters in bitmap, 24651 in gd; block bitmap corrupt.
[922646.673295] Aborting journal on device sda1-8.
[922646.673904] EXT4-fs (sda1): Remounting filesystem read-only
[922646.684017] ------------[ cut here ]------------
[922646.685564] WARNING: CPU: 0 PID: 10001 at /build/linux-oxWk_8/linux-3.13.7/fs/ext4/ext4_jbd2.c:259 __ext4_handle_dirty_metadata+0x17e/0x190 [ext4]()
[922646.685566] Modules linked in: openafs(PO) loop ttm drm_kms_helper drm evdev psmouse processor parport_pc pcspkr serio_raw parport i2c_piix4 thermal_sys button i2c_core ext4 crc16 mbcache jbd2 sg sd_mod crc_t10dif crct10dif_common ata_generic virtio_blk floppy ata_piix ahci libahci virtio_pci virtio_ring virtio libata e1000 scsi_mod
[922646.692926] CPU: 0 PID: 10001 Comm: logrotate Tainted: P           O 3.13-1-amd64 #1 Debian 3.13.7-1
[922646.692929] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[922646.692931] 0000000000000009 ffffffff814a1327 0000000000000000 ffffffff8105ba72
[922646.692935] ffff88000356c2a0 00000000ffffffe2 0000000000000000 ffff88000435f408
[922646.692938] ffffffffa017aa80 ffffffffa015b30e ffff8800083784c8 ffff88001f4ba000
[922646.692941] Call Trace:
[922646.692977] [<ffffffff814a1327>] ? dump_stack+0x41/0x51
[922646.696017] [<ffffffff8105ba72>] ? warn_slowpath_common+0x72/0x90
[922646.699226] [<ffffffffa015b30e>] ? __ext4_handle_dirty_metadata+0x17e/0x190 [ext4]
[922646.699234] [<ffffffffa0135c50>] ? ext4_dirty_inode+0x20/0x50 [ext4]
[922646.699243] [<ffffffffa0163667>] ? ext4_free_blocks+0x5e7/0xb90 [ext4]
[922646.699260] [<ffffffff81096b9c>] ? wake_up_bit+0xc/0x20
[922646.699269] [<ffffffffa015779c>] ? ext4_ext_remove_space+0x7bc/0xff0 [ext4]
[922646.699278] [<ffffffffa0159e48>] ? ext4_ext_truncate+0x98/0xc0 [ext4]
[922646.699284] [<ffffffffa0134169>] ? ext4_truncate+0x379/0x3c0 [ext4]
[922646.699291] [<ffffffffa0134cc9>] ? ext4_evict_inode+0x459/0x4b0 [ext4]
[922646.699312] [<ffffffff811929c3>] ? evict+0xa3/0x190
[922646.699316] [<ffffffff8118ece8>] ? dentry_kill+0x1e8/0x230
[922646.699319] [<ffffffff8118ed84>] ? dput+0x54/0xf0
[922646.699334] [<ffffffff8117afe8>] ? __fput+0x148/0x210
[922646.699346] [<ffffffff81078ea7>] ? task_work_run+0x97/0xd0
[922646.699356] [<ffffffff81012969>] ? do_notify_resume+0x59/0x90
[922646.699366] [<ffffffff814ae7b2>] ? int_signal+0x12/0x17
[922646.699385] ---[ end trace bfc86d6bd5d1e863 ]---
[922646.712017] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[922646.712017] IP: [<ffffffffa014a7cc>] __ext4_error_inode+0x2c/0x150 [ext4]
[922646.712017] PGD 1bcf1067 PUD 1f3bc067 PMD 0
[922646.712017] Oops: 0000 [#1] SMP
[922646.712017] Modules linked in: openafs(PO) loop ttm drm_kms_helper drm evdev psmouse processor parport_pc pcspkr serio_raw parport i2c_piix4 thermal_sys button i2c_core ext4 crc16 mbcache jbd2 sg sd_mod crc_t10dif crct10dif_common ata_generic virtio_blk floppy ata_piix ahci libahci virtio_pci virtio_ring virtio libata e1000 scsi_mod
[922646.712017] CPU: 0 PID: 10001 Comm: logrotate Tainted: P        W  O 3.13-1-amd64 #1 Debian 3.13.7-1
[922646.712017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[922646.712017] task: ffff880000f11800 ti: ffff880000e90000 task.ti: ffff880000e90000
[922646.712017] RIP: 0010:[<ffffffffa014a7cc>]  [<ffffffffa014a7cc>] __ext4_error_inode+0x2c/0x150 [ext4]
[922646.712017] RSP: 0018:ffff880000e91b58  EFLAGS: 00010292
[922646.712017] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000080001
[922646.712017] RDX: 00000000000012ea RSI: ffffffffa018291d RDI: 0000000000000000
[922646.712017] RBP: ffff880000e91be8 R08: ffffffffa017fb38 R09: 0000000000000005
[922646.712017] R10: 0000000000000000 R11: ffff880000e9192e R12: 0000000000080001
[922646.712017] R13: ffffffffa017aa80 R14: 00000000000012ea R15: ffffffffa017fb38
[922646.712017] FS:  00007f4357fb0800(0000) GS:ffff88001fc00000(0000) knlGS:0000000000000000
[922646.712017] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[922646.712017] CR2: 00000000001f8000 CR3: 000000001bd00000 CR4: 00000000000006f0
[922646.712017] Stack:
[922646.712017] ffffffffa015b30e 00000000000012ea ffffffff8149efa2 0000000000000010
[922646.712017] ffff880000e91bc8 ffff880000e91b88 0000000000000103 bfc86d6bd5d1e863
[922646.712017] 0000000000003232 ffff88000435f408 ffffffffa015ae88 0000000000000227
[922646.712017] Call Trace:
[922646.712017] [<ffffffffa015b30e>] ? __ext4_handle_dirty_metadata+0x17e/0x190 [ext4]
[922646.712017] [<ffffffff8149efa2>] ? printk+0x4f/0x51
[922646.712017] [<ffffffffa015ae88>] ? ext4_journal_abort_handle+0x38/0xb0 [ext4]
[922646.712017] [<ffffffffa015b285>] ? __ext4_handle_dirty_metadata+0xf5/0x190 [ext4]
[922646.712017] [<ffffffffa0163667>] ? ext4_free_blocks+0x5e7/0xb90 [ext4]
[922646.712017] [<ffffffff81096b9c>] ? wake_up_bit+0xc/0x20
[922646.712017] [<ffffffffa015779c>] ? ext4_ext_remove_space+0x7bc/0xff0 [ext4]
[922646.712017] [<ffffffffa0159e48>] ? ext4_ext_truncate+0x98/0xc0 [ext4]
[922646.712017] [<ffffffffa0134169>] ? ext4_truncate+0x379/0x3c0 [ext4]
[922646.712017] [<ffffffffa0134cc9>] ? ext4_evict_inode+0x459/0x4b0 [ext4]
[922646.712017] [<ffffffff811929c3>] ? evict+0xa3/0x190
[922646.712017] [<ffffffff8118ece8>] ? dentry_kill+0x1e8/0x230
[922646.712017] [<ffffffff8118ed84>] ? dput+0x54/0xf0
[922646.712017] [<ffffffff8117afe8>] ? __fput+0x148/0x210
[922646.712017] [<ffffffff81078ea7>] ? task_work_run+0x97/0xd0
[922646.712017] [<ffffffff81012969>] ? do_notify_resume+0x59/0x90
[922646.712017] [<ffffffff814ae7b2>] ? int_signal+0x12/0x17
[922646.712017] Code: 48 89 e5 41 57 4d 89 c7 41 56 41 89 d6 41 55 49 89 f5 48 c7 c6 1d 29 18 a0 41 54 49 89 cc 53 48 89 fb 48 83 ec 68 4c 89 4c 24 60 <48> 8b 47 28 48 8b 57 40 48 8b 80 f8 02 00 00 48 8b 40 68 89 90
[922646.712017] RIP  [<ffffffffa014a7cc>] __ext4_error_inode+0x2c/0x150 [ext4]
[922646.712017] RSP <ffff880000e91b58>
[922646.712017] CR2: 0000000000000028
[922646.753519] ---[ end trace bfc86d6bd5d1e864 ]---

dumpe2fs on /dev/sda1 reports:

Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          680c70f2-6ff5-49f9-9823-4f1d48062a0c
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              262144
Block count:              1048064
Reserved block count:     10480
Free blocks:              808533
Free inodes:              220750
First block:              0
Block size: 4096
Fragment size:            4096
Reserved GDT blocks:      255
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Feb 21 02:30:29 2014
Last mount time:          Sun Apr 20 14:08:06 2014
Last write time:          Sun Apr 20 14:08:06 2014
Mount count:              29
Maximum mount count:      -1
Last checked:             Fri Feb 21 02:30:29 2014
Check interval:           0 (<none>)
Lifetime writes:          15 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size: 256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       131314
Default directory hash:   half_md4
Directory Hash Seed:      ef50dd1a-28f7-4ef3-baa2-b8e579d852a3
Journal backup:           inode blocks
FS Error count:           1
First error time:         Thu May  1 06:25:13 2014
First error function:     ext4_mb_generate_buddy
First error line #:       756
First error inode #:      0
First error block #:      0
Last error time:          Thu May  1 06:25:13 2014
Last error function:      ext4_mb_generate_buddy
Last error line #:        756
Last error inode #:       0
Last error block #:       0
Journal features:         journal_incompat_revoke
Journal size:             64M
Journal length:           16384
Journal sequence:         0x0003f20f
Journal start:            175
Journal errno:            -5

Cheers,
--nwf;

--Mit9XoPEfICDqq/V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlNidV8ACgkQTeQabvr9Tc+7kwCfcUhsqQGvotj8p+KWkx9eC4TR
hj0An26ViTI0957J7AndkdZFTVrt6ciM
=32n3
-----END PGP SIGNATURE-----

--Mit9XoPEfICDqq/V--
