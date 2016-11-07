From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Mon, 07 Nov 2016 20:31:10 +0000
Message-ID: <bug-187051-13602-ZDHJdA6Rba@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751579AbcKGUbQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 15:31:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 9F7DB20263
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 20:31:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 297F620220
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 20:31:11 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #6 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca> ---
(In reply to Theodore Tso from comment #3)
> So /usr/share/help/oc/totem/figures is a *directory*?    A directory has no
> business being on the orphan list, so something very strange is indeed going
> on.

It *is* possible to have a directory on the orphan list, since it is possible
to have an open-unlinked directory if one cd's into the directory before it is
unlinked (note nlink = 0, dtime is an inode number, not time):

    $ mkdir foo
    $ cd foo
    $ rmdir ../foo
    $ ls -lid .
    289432 drwxrwxr-x 0 mythtv mythtv 0 Nov  7 13:23 .
    $ sudo debugfs -c -R "stat <289432>" /dev/vg_basemyth/lvroot.basemyth 
    debugfs 1.42.7.wc2 (07-Nov-2013)
    Inode: 289432   Type: directory    Mode:  0775   Flags: 0x0
    Generation: 2752543570    Version: 0x00000000:00000002
    User:   500   Group:   500   Size: 4096
    File ACL: 0    Directory ACL: 0
    Links: 0   Blockcount: 8
    Fragment:  Address: 0    Number: 0    Size: 0
     ctime: 0x5820e2b5:4aa59b94 -- Mon Nov  7 13:23:17 2016
     atime: 0x5820e2b0:0048b0c8 -- Mon Nov  7 13:23:12 2016
     mtime: 0x5820e2b0:0048b0c8 -- Mon Nov  7 13:23:12 2016
    crtime: 0x5820e2b0:0048b0c8 -- Mon Nov  7 13:23:12 2016
     dtime: 0x0003f42b -- Sat Jan  3 16:58:35 1970
    Size of extra inode fields: 28
    BLOCKS:
    (0):1258994

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
