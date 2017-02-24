From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194689] New: tune2fs: bugs in handling resize inode/undo file
 handling
Date: Fri, 24 Feb 2017 07:15:42 +0000
Message-ID: <bug-194689-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58962 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751005AbdBXHPp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 24 Feb 2017 02:15:45 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B5DC128756
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 07:15:44 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BD22728792
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 07:15:42 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194689

            Bug ID: 194689
           Summary: tune2fs: bugs in handling resize inode/undo file
                    handling
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: admin@tho-otto.de
        Regression: No

There seem to be some bugs in handling the combination of resizing inodes and
specifying an undo file with the -z option. Before each run, i have created a
test image with the command:

$ mke2fs -F -o Linux -I 128 test.img 512
mke2fs 1.43.5-WIP (17-Feb-2017)
test.img contains a ext2 file system
        created on Fri Feb 24 07:54:45 2017
Creating filesystem with 512 1k blocks and 64 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done


Then, when running 

$ E2FSPROGS_UNDO_DIR=. tune2fs -f -I 256 -z my.e2undo test.img

I get the following output

tune2fs 1.43.5-WIP (17-Feb-2017)
Resizing inodes could take some time.
Proceed anyway (or wait 5 seconds) ? (y,N) <proceeding>
Overwriting existing filesystem; this can be undone using the command:
    e2undo ./tune2fs-test.img.e2undo test.img

Resizing inodes could take some time.
Proceed anyway (or wait 5 seconds) ? (y,N) n

./tune2fs-test.img.e2undo: while force-closing undo file


It asked two times. I let the first question timeout, but the second time it
waited forever. Also, the last line looks a bit confusing, apparently it got an
error but does not tell which one.


Next, i tried
$ E2FSPROGS_UNDO_DIR=/nonexisting tune2fs -f -I 256 -z my.e2undo test.img

tune2fs 1.43.5-WIP (17-Feb-2017)
Resizing inodes could take some time.
Proceed anyway (or wait 5 seconds) ? (y,N) y
Setting inode size 256

i.e. it happily proceeded without ever creating an undo file.


And last, when i run
$ E2FSPROGS_UNDO_DIR=. tune2fs -f -I 256 -z my.e2undo test.img

I get

tune2fs 1.43.5-WIP (17-Feb-2017)
Resizing inodes could take some time.
Proceed anyway (or wait 5 seconds) ? (y,N) y
Overwriting existing filesystem; this can be undone using the command:
    e2undo ./tune2fs-test.img.e2undo test.img

Resizing inodes could take some time.
Proceed anyway (or wait 5 seconds) ? (y,N) y
Setting inode size 256

It created an undo file, but this is the default, ignoring the commandline
option.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
