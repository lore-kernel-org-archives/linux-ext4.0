From: "Bill Huey (hui)" <bill.huey@gmail.com>
Subject: ext4 corruption
Date: Sat, 26 Feb 2011 02:16:37 -0800
Message-ID: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59845 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1BZKQi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 05:16:38 -0500
Received: by bwz15 with SMTP id 15so2580079bwz.19
        for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 02:16:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Maybe this is deletion related since I was creating and destroying a
bunch of file with rsync. I don't know. I'm redoing the rsync with
checksums to see if the data is still in tact. Seems like some bits of
this got corrupted, but I can't tell if it's disk or file system
related.

bill
------------------------------------

Feb 22 19:23:31 finfin kernel: [    2.819633]  sdb1
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
Feb 25 05:01:39 finfin kernel: [    2.405998]  sdb: sdb1
Feb 25 05:02:07 finfin kernel: [   82.487625] EXT4-fs (sdb1): warning:
mounting fs with errors, running e2fsck is recommended
Feb 25 05:02:07 finfin kernel: [   82.657297] EXT4-fs (sdb1): mounted
filesystem with ordered data mode. Opts: (null)
Feb 25 05:09:40 finfin kernel: [    2.408385]  sdb: sdb1
Feb 25 05:14:17 finfin kernel: [    2.438605]  sdb: sdb1
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
