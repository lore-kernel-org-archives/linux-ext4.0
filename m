From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194071] New: data loss using fallocate and mmap
Date: Mon, 06 Feb 2017 10:59:24 +0000
Message-ID: <bug-194071-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdBFK72 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 6 Feb 2017 05:59:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0FDC020263
        for <linux-ext4@vger.kernel.org>; Mon,  6 Feb 2017 10:59:27 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id D65562021A
        for <linux-ext4@vger.kernel.org>; Mon,  6 Feb 2017 10:59:25 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194071

            Bug ID: 194071
           Summary: data loss using fallocate and mmap
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.0+
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: michael@swarm64.com
        Regression: No

Created attachment 254231
  --> https://bugzilla.kernel.org/attachment.cgi?id=254231&action=edit
Example C program

After calling fallocate() on a shared mmap'ed file and writing data into the
newly allocated region, occasionally (first observed after running for ~1 week)
some data is replaced by 0s. The address and size of corrupted data is also not
reproducible.

The initial failure was debugged and reduced to a C++ program that failed with
both gcc and clang, and later to the attached C program. The amount allocated
every iteration was reduced to 1 byte because that caused faster failures, and
wasn't reproducible with higher power of 2 sizes.

Is this a bug or user error?

OS: Ubuntu 16.04.1 LTS
kernel versions: 4.4.0-38-generic, 4.9.7-040907-generic
block device: Observed on both /dev/ram0 and local SSD
ext4 mount options: (rw, relatime,data=ordered)

Unable to reproduce when using the "FALLOC_FL_ZERO_RANGE" flag, and on a tmpfs
ram disk.

Reproduction steps:
sudo mkdir /mnt/ram0
sudo mkfs.ext4 /dev/ram0
sudo mount /dev/ram0 /mnt/ram0/
gcc -O2 tests_mmap_fallocate.c -o tests_mmap_fallocate_gcc
while sudo rm -f /mnt/ram0/tests_mmap_fallocate && sudo
./tests_mmap_fallocate_gcc; do date && sleep 1; done
...
...
...
Value has been modified
(Also nothing found in /var/log/kern.log)

On a development machine the failure only occurs after several days of running
in a loop, but fails within minutes on a virtualized Linux machine on a server.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
