From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] New: mkdir mishandles st_nlink in ext4 directory with
 64997 subdirectories
Date: Mon, 17 Jul 2017 21:23:44 +0000
Message-ID: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52440 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751837AbdGQVXv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Jul 2017 17:23:51 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 27CA725223
        for <linux-ext4@vger.kernel.org>; Mon, 17 Jul 2017 21:23:51 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

            Bug ID: 196405
           Summary: mkdir mishandles st_nlink in ext4 directory with 64997
                    subdirectories
           Product: File System
           Version: 2.5
    Kernel Version: 4.13-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: eggert@cs.ucla.edu
        Regression: No

See the following shell transcript, run in an ext4 directory, for an
illustration of the bug. The first four commands set things up. The 5th command
'mkdir d/64998' calls 'mkdir("d/64998, 0777)' and succeeds. The 6th command
shows that d's resulting st_nlink value is 1, which is incorrect; it should be
65000. I discovered this bug in Fedora 26, which runs Linux 4.11.10; from
inspecting the source it appears the bug is still there in 4.13-rc1.

$ LC_ALL=C
$ export LC_ALL
$ mkdir d d/{1..64997}
$ strace -ve trace=%lstat ls -ld d
lstat("d", {st_dev=makedev(8, 2), st_ino=41565723, st_mode=S_IFDIR|0755,
st_nlink=64999, st_uid=1000, st_gid=1000, st_blksize=4096, st_blocks=2744,
st_size=1404928, st_atime=1500319812 /* 2017-07-17T12:30:12.934815840-0700 */,
st_atime_nsec=934815840, st_mtime=1500319822 /*
2017-07-17T12:30:22.896866173-0700 */, st_mtime_nsec=896866173,
st_ctime=1500319822 /* 2017-07-17T12:30:22.896866173-0700 */,
st_ctime_nsec=896866173}) = 0
drwxr-xr-x. 64999 eggert eggert 1404928 Jul 17 12:30 d
+++ exited with 0 +++
$ mkdir d/64998
$ strace -ve trace=%lstat ls -ld d
lstat("d", {st_dev=makedev(8, 2), st_ino=41565723, st_mode=S_IFDIR|0755,
st_nlink=1, st_uid=1000, st_gid=1000, st_blksize=4096, st_blocks=2744,
st_size=1404928, st_atime=1500319812 /* 2017-07-17T12:30:12.934815840-0700 */,
st_atime_nsec=934815840, st_mtime=1500319845 /*
2017-07-17T12:30:45.104978381-0700 */, st_mtime_nsec=104978381,
st_ctime=1500319845 /* 2017-07-17T12:30:45.104978381-0700 */,
st_ctime_nsec=104978381}) = 0
drwxr-xr-x. 1 eggert eggert 1404928 Jul 17 12:30 d


This bug report follows up on the following downstream bug reports:

https://bugzilla.redhat.com/show_bug.cgi?id=1471967
https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27739

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
