From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186981] New: ext4 is not working on kernel 4.8.6
Date: Sat, 05 Nov 2016 00:19:01 +0000
Message-ID: <bug-186981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbcKEATF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Nov 2016 20:19:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id F1D3C204CF
        for <linux-ext4@vger.kernel.org>; Sat,  5 Nov 2016 00:19:02 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id AF31B204AE
        for <linux-ext4@vger.kernel.org>; Sat,  5 Nov 2016 00:19:01 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186981

            Bug ID: 186981
           Summary: ext4 is not working on kernel 4.8.6
           Product: File System
           Version: 2.5
    Kernel Version: 4.8.6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jonfr1900@jonfr.com
        Regression: No

Created attachment 243681
  --> https://bugzilla.kernel.org/attachment.cgi?id=243681&action=edit
kernel 4.8.6 config regarding ext4 error

This might just be a limited issue to my set-up, but I doubt it. The issue is
that I was attempting to upgrade from 4.7.4 up to 4.8.6. Nothing was changed.
When I did try to boot the new kernel I got a file system error message related
to ext4. This also created a corruption in my /dev/sda3 file system (ext3) and
I had to manually correct it (that might have been due to unclean unmount since
I had to cold reboot the computer). I did test to switch the setting from
compiled in into modules, but that did not solve this issue. The ext3 file
systems mount properly it seems, regardless of the errors I got later on after
cold reboots on the computer.

I did not get into the shell following this issue. I don't think this is any
type of misconfiguration at my end. Since I follow rather regular and stable
setting if possible.

sdb1 is a ext4 file system. While the rest is ext3. I don't have any issue with
kernel 4.7.4 with the same setting. The size is 1TB.

I get this in my rc.log. I'm running Gentoo linux and compiling the kernel with
genkernel (for convince).

----

* Setting system clock using the hardware clock [Local Time] ...
 [ ok ]
 * Autoloaded 0 module(s)
 * Checking local filesystems  ...
/dev/sda3: clean, 1189275/13172736 files, 15645957/52690944 blocks
fsck.ext4: Bad magic number in super-block while trying to open /dev/sdb1
/dev/sdb1:
The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>

/dev/sda1: clean, 880/51200 files, 179161/204800 blocks
/dev/sda4: clean, 663797/47210496 files, 143195124/188826806 blocks
 * Operational error
 [ !! ]
 * Remounting root filesystem read/write ...
 [ ok ]
 * Remounting filesystems ...
 [ ok ]
 * Updating /etc/mtab ...
 * Creating mtab symbolic link
 [ ok ]
 * Activating swap devices ...
 [ ok ]
 * Mounting local filesystems ...
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
 * Some local filesystem failed to mount
 [ !! ]
 * Mounting misc binary format filesystem ...
 [ ok ]
 * Loading custom binary format handlers ...
 [ ok ]
----

Attached is my kernel config for 4.8.6. This was my last attempt to solve this
issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
