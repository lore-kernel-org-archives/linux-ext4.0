From: "Bill Huey (hui)" <bill.huey@gmail.com>
Subject: Re: ext4 corruption
Date: Sat, 26 Feb 2011 03:13:30 -0800
Message-ID: <AANLkTimcKiKgKTVft9N+OVHd5-N+-AscSoimdOfkoBt9@mail.gmail.com>
References: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
	<C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58945 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1BZLNc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 06:13:32 -0500
Received: by bwz15 with SMTP id 15so2598081bwz.19
        for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 03:13:30 -0800 (PST)
In-Reply-To: <C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore,

I did run fsck.ext4 on the file system. It cleared a bunch of errors
and but it's still showing various problems.

Another log of the file system. USB->SATA problems ?
---------------------------------

Feb 22 19:23:31 finfin kernel: [    2.402463] sd 6:0:0:0: [sdb]
3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Feb 22 19:23:31 finfin kernel: [    2.403585] sd 6:0:0:0: [sdb] Write
Protect is off
Feb 22 19:23:31 finfin kernel: [    2.405920]  sdb:
Feb 22 19:23:31 finfin kernel: [    2.819633]  sdb1
Feb 22 19:23:31 finfin kernel: [    2.821592] sd 6:0:0:0: [sdb]
Attached SCSI disk
Feb 22 19:27:40 finfin kernel: [  263.857108]  sdb: sdb1
Feb 22 20:03:18 finfin kernel: [ 2402.182269] EXT4-fs (sdb1): mounted
filesystem with ordered data mode. Opts: (null)
Feb 25 03:49:40 finfin kernel: [203184.800029] EXT4-fs (sdb1):
warning: mounting fs with errors, running e2fsck is recommended
Feb 25 03:49:41 finfin kernel: [203184.980730] EXT4-fs (sdb1): mounted
filesystem with ordered data mode. Opts: (null)
Feb 25 04:41:26 finfin kernel: [206290.181230] JBD: Spotted dirty
metadata buffer (dev = sdb1, blocknr = 0). There's a risk of
filesystem corruption in case of system crash.
Feb 25 05:01:39 finfin kernel: [    2.402538] sd 6:0:0:0: [sdb]
3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Feb 25 05:01:39 finfin kernel: [    2.403659] sd 6:0:0:0: [sdb] Write
Protect is off
Feb 25 05:01:39 finfin kernel: [    2.405998]  sdb: sdb1
Feb 25 05:01:39 finfin kernel: [    2.424879] sd 6:0:0:0: [sdb]
Attached SCSI disk
Feb 25 05:02:07 finfin kernel: [   82.487625] EXT4-fs (sdb1): warning:
mounting fs with errors, running e2fsck is recommended
Feb 25 05:02:07 finfin kernel: [   82.657297] EXT4-fs (sdb1): mounted
filesystem with ordered data mode. Opts: (null)
Feb 25 05:09:40 finfin kernel: [    2.404933] sd 6:0:0:0: [sdb]
3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Feb 25 05:09:40 finfin kernel: [    2.406043] sd 6:0:0:0: [sdb] Write
Protect is off
Feb 25 05:09:40 finfin kernel: [    2.408385]  sdb: sdb1
Feb 25 05:09:40 finfin kernel: [    2.411134] sd 6:0:0:0: [sdb]
Attached SCSI disk
Feb 25 05:14:17 finfin kernel: [    2.435019] sd 6:0:0:0: [sdb]
3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Feb 25 05:14:17 finfin kernel: [    2.436139] sd 6:0:0:0: [sdb] Write
Protect is off
Feb 25 05:14:17 finfin kernel: [    2.438605]  sdb: sdb1
Feb 25 05:14:17 finfin kernel: [    2.441353] sd 6:0:0:0: [sdb]
Attached SCSI disk
Feb 25 05:16:21 finfin kernel: [  174.548463] EXT4-fs (sdb1): warning:
mounting fs with errors, running e2fsck is recommended
Feb 25 05:16:21 finfin kernel: [  174.728174] EXT4-fs (sdb1): mounted
filesystem with ordered data mode. Opts: (null)
Feb 25 15:18:20 finfin kernel: [36293.209497] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40242283) - no `.' or `..'
Feb 25 15:18:20 finfin kernel: [36293.209594] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40242282) - no `.' or `..'
Feb 25 15:18:20 finfin kernel: [36293.209668] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40242281) - no `.' or `..'
Feb 25 15:18:20 finfin kernel: [36293.209739] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40242280) - no `.' or `..'
Feb 25 15:18:20 finfin kernel: [36293.209745] EXT4-fs warning (device
sdb1): ext4_rmdir: empty directory has too many links (8)
Feb 25 15:18:20 finfin kernel: [36293.209818] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40242279) - no `.' or `..'
Feb 25 15:18:20 finfin kernel: [36293.209824] EXT4-fs warning (device
sdb1): ext4_rmdir: empty directory has too many links (5)
Feb 25 15:18:20 finfin kernel: [36293.209892] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40242278) - no `.' or `..'
Feb 25 15:18:20 finfin kernel: [36293.209898] EXT4-fs warning (device
sdb1): ext4_rmdir: empty directory has too many links (3)
Feb 25 15:18:20 finfin kernel: [36293.226488] EXT4-fs warning (device
sdb1): ext4_rmdir: empty directory has too many links (125)
Feb 25 15:18:45 finfin kernel: [36317.996660] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40247537) - no data block
Feb 25 15:18:45 finfin kernel: [36317.996671] EXT4-fs warning (device
sdb1): ext4_rmdir: empty directory has too many links (24906)
Feb 25 15:19:38 finfin kernel: [36371.180386] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40239122) - no `.' or `..'
Feb 25 15:19:38 finfin kernel: [36371.232941] EXT4-fs warning (device
sdb1): ext4_rmdir: empty directory has too many links (3)
Feb 25 15:19:38 finfin kernel: [36371.343549] EXT4-fs warning (device
sdb1): ext4_rmdir: empty directory has too many links (5)
Feb 25 15:19:38 finfin kernel: [36371.397308] EXT4-fs warning (device
sdb1): empty_dir: bad directory (dir #40239106) - no `.' or `..'
Feb 25 18:13:27 finfin kernel: [46799.800244] EXT4-fs (sdb1): mounted
filesystem with ordered data mode. Opts: (null)
Feb 25 21:51:47 finfin kernel: [59900.021575] EXT4-fs (sdb1): mounted
filesystem with ordered data mode. Opts: (null)
Feb 26 02:19:27 finfin kernel: [75959.826438] sd 6:0:0:0: [sdb]
Unhandled error code
Feb 26 02:19:27 finfin kernel: [75959.826444] sd 6:0:0:0: [sdb]
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Feb 26 02:19:27 finfin kernel: [75959.826450] sd 6:0:0:0: [sdb] CDB:
Read(10): 28 00 ac 44 00 3f 00 00 08 00
