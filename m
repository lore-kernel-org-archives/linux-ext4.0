Return-Path: <SRS0=pBWG=MZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60982 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbeJMXlj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Oct 2018 19:41:39 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CE6E429537
        for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2018 16:03:56 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 200681] [inline_data] read() does not see what write() has just
 written through different FD in the same thread
Date: Sat, 13 Oct 2018 16:03:56 +0000
Message-ID: <bug-200681-13602-7meqM9e9et@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200681-13602@https.bugzilla.kernel.org/>
References: <bug-200681-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=200681

--- Comment #6 from Anatoly Trosinenko (anatoly.trosinenko@gmail.com) ---
It looks like the difference was that I have specified 8M partition size. How
to reproduce it (I repeat parts of your documentation just to make sure I have
got it right):

1) Checkout master branch of torvalds/linux (tested on commit bab5c80b211)
2) Copy fstests/kernel-configs/x86_64-config-4.14 to .config and compile after
`make olddefconfig`
3) Take the attached repro.c and execute the following commands:

$ gcc --static repro.c -o repro # Inside /tmp/kvm-xfstest-$USER
$ kvm-xfstest shell
root@kvm-xfstests:~# mount /vtmp
root@kvm-xfstests:~# mke2fs -Fq -t ext4 -O inline_data -I 1024 /dev/vdc 8M
/dev/vdc contains a ext4 file system
        last mounted on /vdc on Sat Oct 13 15:59:40 2018
root@kvm-xfstests:~# mount /vdc
[    9.812236] EXT4-fs (vdc): mounted filesystem with ordered data mode. Opts:
(null)
root@kvm-xfstests:~# cd /vdc
root@kvm-xfstests:/vdc# /vtmp/repro
First write res = 48
Second write res = 17968
res1 = 17968 res2 = 48          first bytes of data are: 00 00 00...

When the full partition is used for the filesystem, the bug is not
reproducible, as expected.

Maybe with a 8M partition there is just not enough room for data, so maybe
everything is right except for the return codes saying everything was written
successfully instead of ENOSPC... (but the file size is 18016 as if all the
data were written to it).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
