From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Wed, 03 May 2017 17:48:32 +0000
Message-ID: <bug-195561-13602-7oau8MrC3j@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40364 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753255AbdECRss (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 May 2017 13:48:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9663A2866B
        for <linux-ext4@vger.kernel.org>; Wed,  3 May 2017 17:48:47 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #26 from Theodore Tso (tytso@mit.edu) ---
Can you use e2fsck -fy /dev/devXX on the sdcard *before* you copy the file?

How was the sdcard formatted?

Can you give me a clean reproduction that doesn't involve using AOSP userspace?

For example, on a build an x86 kernel and then boot it using using
kvm-xfstests[1].

[1]
https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md

Then try to reproduce it there.  For example:

% kvm-xfstests shell
...
root@kvm-xfstests:~# mke2fs -F -t ext4 /dev/vdc
mke2fs 1.43.5-WIP-ed1e950f (26-Apr-2017)
/dev/vdc contains a ext4 file system
        last mounted on /vdc on Wed May  3 13:44:28 2017
Creating filesystem with 1310720 4k blocks and 327680 inodes
Filesystem UUID: 15426c7f-5695-4cd8-9b2e-78288883b877
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

root@kvm-xfstests:~# mount /dev/vdc /vdc
[   84.418730] EXT4-fs (vdc): mounted filesystem with ordered data mode. Opts:
(null)
root@kvm-xfstests:~# dd if=/dev/zero of=/vdc/test.img bs=1G count=3
3+0 records in
3+0 records out
3221225472 bytes (3.2 GB) copied, 18.6019 s, 173 MB/s
[  107.766622] dd (2616) used greatest stack depth: 5924 bytes left
root@kvm-xfstests:~# umount /vdc
root@kvm-xfstests:~# e2fsck -fy /dev/vdc
e2fsck 1.43.5-WIP-ed1e950f (26-Apr-2017)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdc: 12/327680 files (0.0% non-contiguous), 828511/1310720 blocks
root@kvm-xfstests:~# 

(You can exit the VM by typing Control-A x -- control-A followed by the 'x'
character.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
