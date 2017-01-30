From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193661] New: xattr  ext4_xattr_block_find, bad block on cleanly
 formatted ext4 partition
Date: Mon, 30 Jan 2017 16:06:21 +0000
Message-ID: <bug-193661-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752428AbdA3QGa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 11:06:30 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 47028202AE
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:06:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 22AAC20256
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:06:22 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193661

            Bug ID: 193661
           Summary: xattr  ext4_xattr_block_find, bad block on cleanly
                    formatted ext4 partition
           Product: File System
           Version: 2.5
    Kernel Version: all versions tested, from 3.19 through to 4.10-rc6
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: colin.king@canonical.com
        Regression: No

Reproducer:

Ran inside a 8 proc VM instance, i386 kernel, 4MB of memory with the stress-ng
xattr stress test on a cleanly formated ext4 partition (e.g. mkfs.ext4
/dev/vdb1):

using stress-ng - to build from source on ubuntu systems:
   git clone git://kernel.ubuntu.com/cking/stress-ng
   sudo apt-get build-dep stress-ng
   cd stress-ng
   make

test script to invoke the stressor, needs to be run as root:

#!/bin/bash -x
for i in $(seq 30)
do
        ./stress-ng/stress-ng --xattr 8 -t 10
        rc=$?
        if [ $rc -ne 0 ]; then
                exit 1
        fi
done

This will trigger errors such as:

EXT4-fs error (device vdb1): ext4_xattr_block_find:802: inode #131074: comm
stress-ng-xattr: bad block 532519

and more often than not one needs to fsck the partition.

I've tested this on mainline kernels from 3.19 through to 4.10-rc6 and I can
trigger this on these kernels only on i386 systems. I've tested other 32 bit
platforms (32 bit arm, raspberry pi 2) but can't trigger it.  I cannot trigger
this issue on amd64 builds of the same kernels in a VM.

I put some debug into ext4_xattr_block_set() at the /* update the inode. *
comment and the bug does not trip, so it seems that this reduces the risk of
teh race condition occurring.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
