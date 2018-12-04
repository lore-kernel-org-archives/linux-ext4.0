Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33918 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbeLDShF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 13:37:05 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C691A2C4BE
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 18:37:03 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 18:37:01 +0000
Message-ID: <bug-201685-13602-dEFmzGHv7r@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Lukáš Krejčí (lskrejci@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lskrejci@gmail.com

--- Comment #232 from Lukáš Krejčí (lskrejci@gmail.com) ---
Created attachment 279845
  --> https://bugzilla.kernel.org/attachment.cgi?id=279845&action=edit
git bisect between v4.18 and 4.19-rc1

Hello,

I am able to reproduce the data corruption under Qemu, the issue usually shows
itself fairly quickly (within a minute or two). Generally, the bug was very
likely to appear when (un)installing packages with apt.

I ran a bisect with the following result (full bisect log is attached):
# first bad commit: [6ce3dd6eec114930cf2035a8bcb1e80477ed79a8] blk-mq: issue
directly if hw queue isn't busy in case of 'none'

You can revert the commit from linux v4.19 with: git revert --no-commit
8824f62246bef 6ce3dd6eec114 (did not try compiling and running the kernel
myself yet)

Obviously, this commit could just make the issue more prominent than it already
is, especially since some are saying that CONFIG_SCSI_MQ_DEFAULT=n does not
make the problem go away. The commit was added fairly early in the 4.19 merge
window, though, so if v4.18 is fine, it should be one of the 67 other commits
in that range.
The only thing I can think of is that the people that had blk-mq off in the
kernel config still had it enabled on the kernel command line
(scsi_mod.use_blk_mq=1, /sys/module/scsi_mod/parameters/use_blk_mq would then
be set to Y).

The bad commits in the bisect log I am fairly certain of because the corruption
was evident, the good ones less so since I did only limited testing (about 3-6
VM restarts and couple minutes of running apt) and did not use the reproducer
script posted here.

There are a few preconditions that make the errors much more likely to appear:
- Ubuntu Desktop 18.10; Ubuntu Server 18.10 did not work (I guess there are a
few more things installed by default like Snap packages that are mounted on
startup, dpkg automatically searches for updates, etc.)
- as little RAM as possible (300 MB), 256 MB did not boot - this makes sure
swap is used (~200 MiB out of 472 MiB total)
- drive has to be the default if=ide, virtio-blk (-drive <...>,if=virtio) and
virtio-scsi (-drive file=<file>,media=disk,if=none,id=hd -device
virtio-scsi-pci,id=scsi -device scsi-hd,drive=hd) did not produce corruption (I
did not try setting num-queues, though)
- scsi_mod.use_blk_mq=1 has to be used, no errors for me without it (Ubuntu
mainline kernel 4.19.1 and later has this on by default)

Before running the bisect, I tested these kernels (all Ubuntu mainline from
http://kernel.ubuntu.com/~kernel-ppa/mainline/):

Had FS corruption:
4.19-rc1
4.19
4.19.1
4.19.2
4.19.3
4.19.4
4.19.5
4.19.6

No corruption (yet):
4.18
4.18.20

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
