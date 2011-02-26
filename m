From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext4 corruption
Date: Sat, 26 Feb 2011 06:10:55 -0500
Message-ID: <C5B8C496-E8F1-4BF7-9A51-373C0C63E357@mit.edu>
References: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Bill Huey (hui) <bill.huey@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:60264 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888Ab1BZLK7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Feb 2011 06:10:59 -0500
In-Reply-To: <AANLkTin5hN-gnpmgntApSSrWVWJPQqK99tPJtfmFn5++@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 26, 2011, at 5:16 AM, Bill Huey (hui) wrote:

> Maybe this is deletion related since I was creating and destroying a
> bunch of file with rsync. I don't know. I'm redoing the rsync with
> checksums to see if the data is still in tact. Seems like some bits of
> this got corrupted, but I can't tell if it's disk or file system
> related.

I'd run e2fsck before you do anything else.   Some of the error
messages listed below, especially the ones about bad link
counts on empty directories, smells very much like the inode
table got corrupted.

-- Ted


> 
> bill
> ------------------------------------
> 
> Feb 22 19:23:31 finfin kernel: [    2.819633]  sdb1
> Feb 22 19:27:40 finfin kernel: [  263.857108]  sdb: sdb1
> Feb 22 20:03:18 finfin kernel: [ 2402.182269] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Feb 25 03:49:40 finfin kernel: [203184.800029] EXT4-fs (sdb1):
> warning: mounting fs with errors, running e2fsck is recommended
> Feb 25 03:49:41 finfin kernel: [203184.980730] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Feb 25 04:41:26 finfin kernel: [206290.181230] JBD: Spotted dirty
> metadata buffer (dev = sdb1, blocknr = 0). There's a risk of
> filesystem corruption in case of system crash.
> Feb 25 05:01:39 finfin kernel: [    2.405998]  sdb: sdb1
> Feb 25 05:02:07 finfin kernel: [   82.487625] EXT4-fs (sdb1): warning:
> mounting fs with errors, running e2fsck is recommended
> Feb 25 05:02:07 finfin kernel: [   82.657297] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Feb 25 05:09:40 finfin kernel: [    2.408385]  sdb: sdb1
> Feb 25 05:14:17 finfin kernel: [    2.438605]  sdb: sdb1
> Feb 25 05:16:21 finfin kernel: [  174.548463] EXT4-fs (sdb1): warning:
> mounting fs with errors, running e2fsck is recommended
> Feb 25 05:16:21 finfin kernel: [  174.728174] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Feb 25 15:18:20 finfin kernel: [36293.209497] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40242283) - no `.' or `..'
> Feb 25 15:18:20 finfin kernel: [36293.209594] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40242282) - no `.' or `..'
> Feb 25 15:18:20 finfin kernel: [36293.209668] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40242281) - no `.' or `..'
> Feb 25 15:18:20 finfin kernel: [36293.209739] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40242280) - no `.' or `..'
> Feb 25 15:18:20 finfin kernel: [36293.209745] EXT4-fs warning (device
> sdb1): ext4_rmdir: empty directory has too many links (8)
> Feb 25 15:18:20 finfin kernel: [36293.209818] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40242279) - no `.' or `..'
> Feb 25 15:18:20 finfin kernel: [36293.209824] EXT4-fs warning (device
> sdb1): ext4_rmdir: empty directory has too many links (5)
> Feb 25 15:18:20 finfin kernel: [36293.209892] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40242278) - no `.' or `..'
> Feb 25 15:18:20 finfin kernel: [36293.209898] EXT4-fs warning (device
> sdb1): ext4_rmdir: empty directory has too many links (3)
> Feb 25 15:18:20 finfin kernel: [36293.226488] EXT4-fs warning (device
> sdb1): ext4_rmdir: empty directory has too many links (125)
> Feb 25 15:18:45 finfin kernel: [36317.996660] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40247537) - no data block
> Feb 25 15:18:45 finfin kernel: [36317.996671] EXT4-fs warning (device
> sdb1): ext4_rmdir: empty directory has too many links (24906)
> Feb 25 15:19:38 finfin kernel: [36371.180386] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40239122) - no `.' or `..'
> Feb 25 15:19:38 finfin kernel: [36371.232941] EXT4-fs warning (device
> sdb1): ext4_rmdir: empty directory has too many links (3)
> Feb 25 15:19:38 finfin kernel: [36371.343549] EXT4-fs warning (device
> sdb1): ext4_rmdir: empty directory has too many links (5)
> Feb 25 15:19:38 finfin kernel: [36371.397308] EXT4-fs warning (device
> sdb1): empty_dir: bad directory (dir #40239106) - no `.' or `..'
> Feb 25 18:13:27 finfin kernel: [46799.800244] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Feb 25 21:51:47 finfin kernel: [59900.021575] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

