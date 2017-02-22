From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193661] xattr  ext4_xattr_block_find, bad block on cleanly
 formatted ext4 partition
Date: Wed, 22 Feb 2017 00:24:33 +0000
Message-ID: <bug-193661-13602-XFyzym7OFf@https.bugzilla.kernel.org/>
References: <bug-193661-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39396 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752298AbdBVAYk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 21 Feb 2017 19:24:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8CA272853E
        for <linux-ext4@vger.kernel.org>; Wed, 22 Feb 2017 00:24:39 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 44F8A2853E
        for <linux-ext4@vger.kernel.org>; Wed, 22 Feb 2017 00:24:39 +0000 (UTC)
In-Reply-To: <bug-193661-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193661

Christian Kujau (lists@nerdbynature.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #9 from Christian Kujau (lists@nerdbynature.de) ---
Wow, this triggers in a Debian/unstable 64-bit VM here after the first run:

$ mkfs.ext4 /dev/sdd
$ mount -t ext4 /dev/sdd /mnt/disk && cd /mnt/disk
$ time ~/193661.sh
++ seq 30
+ for i in $(seq 30)
+ /usr/local/sbin/stress-ng --xattr 8 -t 10
stress-ng: info:  [2639] dispatching hogs: 8 xattr
stress-ng: info:  [2639] cache allocate: default cache size: 6144K
stress-ng: fail:  [2647] stress-ng-xattr: fsetxattr failed, errno=117
(Structure needs cleaning)
stress-ng: error: [2639] process 2647 (stress-ng-xattr) terminated with an
error, exit status=1
stress-ng: info:  [2639] unsuccessful run completed in 10.01s
+ rc=2
+ '[' 2 -ne 0 ']'
+ exit 1

real    0m10.019s
user    0m1.460s
sys     0m26.752s

$ dmesg | tail -2
[  494.311212] EXT4-fs (sdd): mounted filesystem with ordered data mode. Opts:
(null)
[  550.828337] EXT4-fs error (device sdd): ext4_xattr_block_find:786: inode
#524292: comm stress-ng-xattr: bad block 2105384

$ uname -rv
4.9.0-1-amd64 #1 SMP Debian 4.9.6-3 (2017-01-28)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
