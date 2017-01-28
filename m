From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Sat, 28 Jan 2017 12:25:53 +0000
Message-ID: <bug-187051-13602-5ZbZ0HlsVa@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751503AbdA1Meb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 28 Jan 2017 07:34:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 41E95203FB
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2017 12:25:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 12C97203E9
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2017 12:25:55 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #8 from Hussam Al-Tayeb <me@hussam.eu.org> ---
Hi. It just happened again.


[root@hades hussam]# debugfs /dev/dm-0
debugfs 1.43.3 (04-Sep-2016)
debugfs:  stat <58073259>
Inode: 58073259   Type: directory    Mode:  0755   Flags: 0x80000
Generation: 1123105798    Version: 0x00000000:0000003e
User:     0   Group:     0   Project:     0   Size: 4096
File ACL: 0    Directory ACL: 0
Links: 2   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x58709c64:841efcb0 -- Sat Jan  7 09:44:36 2017
 atime: 0x588bc31e:c21e1c40 -- Sat Jan 28 00:01:02 2017
 mtime: 0x58709c4e:00000000 -- Sat Jan  7 09:44:14 2017
crtime: 0x58709c64:6127674c -- Sat Jan  7 09:44:36 2017
Size of extra inode fields: 32
Inode checksum: 0xfb5c96a4
EXTENTS:
(0):232268326
debugfs:  quit
[root@hades hussam]# debugfs -R 'ncheck 58073259' /dev/dm-0
debugfs 1.43.3 (04-Sep-2016)
Inode    Pathname
58073259    /usr/share/swig/3.0.11/scilab

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
