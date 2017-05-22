From: Marc Thomas <marc@dragonfly.plus.com>
Subject: e2fsck bug? - Sparse files corrupt after "e2fsck -E bmap2extent".
Date: Tue, 23 May 2017 00:20:59 +0100
Message-ID: <a7a4fc1f-c1d9-bd69-cc2a-1a8094931e6d@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout04.plus.net ([212.159.14.19]:39041 "EHLO
        avasout04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758930AbdEVX2n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 May 2017 19:28:43 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by anvil.lan (8.15.2/8.15.2) with ESMTP id v4MNKxa8022793
        for <linux-ext4@vger.kernel.org>; Tue, 23 May 2017 00:21:00 +0100
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I hope this is the correct place for ext4 / e2fsprogs bug reports. I
think this is a bug.

As per the title, I've discovered sparse files appear corrupt after
running "e2fsck -E bmap2extent" on a filesystem I'm migrating.
Tested with kernel.org 4.10.15 and 4.11.1, using e2fsprogs-1.43.4 on an
x86_64 system.

In short, I'm carrying out a data migration from a snapshot of an ext3
filesystem to new storage, then expanding the filesystem, converting (in
place) to ext4 (as per
https://ext4.wiki.kernel.org/index.php/UpgradeToExt4), before
de-fragmenting the new filesystem with e4defrag.

As part of the testing, I created md5sums of all the source files. After
a "dry run" of the migration, a minority of files (approx 30 out of
1095578 inodes) were found to be corrupt (ie the md5sum had changed).

I repeated the process a second time, checking the md5sums after each
step of the migration. It appears the corruption occurs after running
"e2fsck -E bmap2extent -fy" on the newly converted ext4 filesystem.

The one thing I can find in common is all the affected files are sparse
files.

Here's a few example files:

linux-2.6.30/arch/x86/kernel/acpi/realmode/wakeup.bin: FAILED
linux-2.6.30/arch/x86/boot/compressed/vmlinux.bin: FAILED
marc.old/.mozilla/firefox/ecyfs7l9.default/Cache/_CACHE_003_: FAILED
Linux4.x/linux-4.10.12/arch/x86/realmode/rm/realmode.bin: FAILED
Linux4.x/linux-4.10.1/arch/x86/realmode/rm/realmode.bin: FAILED

They are all definitely sparse files, eg:

$ ls -l Linux4.x/linux-4.10.1/arch/x86/realmode/rm/realmode.bin
-rwxr-xr-x 1 marc users 21080 Mar  8 12:03
Linux4.x/linux-4.10.1/arch/x86/realmode/rm/realmode.bin

$ du -k Linux4.x/linux-4.10.1/arch/x86/realmode/rm/realmode.bin
16      Linux4.x/linux-4.10.1/arch/x86/realmode/rm/realmode.bin

$ du --apparent -k Linux4.x/linux-4.10.1/arch/x86/realmode/rm/realmode.bin
21      Linux4.x/linux-4.10.1/arch/x86/realmode/rm/realmode.bin


Would you agree this is a bug? As I understand it, reading from an
"unpopulated" region of a sparse file should return all zeros - so the
md5sum should be the same before and after migration.

I'm happy to provide more details and do testing if required. I have an
offline copy of the source filesystem so can run the migration again.
Let me know if there's anything you need.

Thanks & Kind Regards,
Marc
