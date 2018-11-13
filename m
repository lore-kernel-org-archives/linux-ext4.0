Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725748AbeKNFl4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 14 Nov 2018 00:41:56 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4FB042B1FB
        for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2018 19:42:20 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] New: ext4 file system corruption
Date: Tue, 13 Nov 2018 19:42:20 +0000
Message-ID: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

            Bug ID: 201685
           Summary: ext4 file system corruption
           Product: File System
           Version: 2.5
    Kernel Version: maybe one of 4.18.18 4.19.1 4.20-rc2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: claude@mathr.co.uk
        Regression: No

Created attachment 279431
  --> https://bugzilla.kernel.org/attachment.cgi?id=279431&action=edit
dmesg 4.18.18 amdgpu.dc=0

My system was fine when I shut it down on Sunday Nov 11.  Today Nov 13 I booted
4.19.1, built two new kernels 4.20-rc2 4.18.18 (using a tmpfs, not the SSD or
HDD), then booted into those kernels briefly (to test if a different bug had
been fixed).  Finally I booted into 4.18.18 (setting amdgpu.dc=0 to workaround
my other bug), and after some moments experienced symptoms of filesystem
corruption on opening an xterm:

    sed: error while loading shared libraries:
/lib/x86_64-linux-gnu/libattr.so.1: unexpected PLT reloc type 0x00000107
    sed: error while loading shared libraries:
/lib/x86_64-linux-gnu/libattr.so.1: unexpected PLT reloc type 0x00000107
    claude@eiskaffee:~$ 

I fixed it by extracting the relevant file from the Debian archive on a
different machine and using `cat` with `bash` shell IO redirection to overwrite
the corrupted shared library file on my problem machine.

Here are the relevant versions extracted from my syslog:

    Nov 13 15:45:49 eiskaffee kernel: [    0.000000] Linux version 4.19.1
(claude@eiskaffee) (gcc version 8.2.0 (Debian 8.2.0-9)) #1 SMP Tue Nov 6
14:58:04 GMT 2018
    Nov 13 18:44:12 eiskaffee kernel: [    0.000000] Linux version 4.20.0-rc2
(claude@eiskaffee) (gcc version 8.2.0 (Debian 8.2.0-9)) #1 SMP Tue Nov 13
16:38:55 GMT 2018
    Nov 13 18:45:00 eiskaffee kernel: [    0.000000] Linux version 4.18.18
(claude@eiskaffee) (gcc version 8.2.0 (Debian 8.2.0-9)) #1 SMP Tue Nov 13
16:23:11 GMT 2018
    Nov 13 18:46:13 eiskaffee kernel: [    0.000000] Linux version 4.18.18
(claude@eiskaffee) (gcc version 8.2.0 (Debian 8.2.0-9)) #1 SMP Tue Nov 13
16:23:11 GMT 2018

mount says:

    /dev/nvme0n1p2 on / type ext4 (rw,relatime,errors=remount-ro)


The machine in question is my production workstation, so I don't feel like
testing anything that might result in data loss.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
