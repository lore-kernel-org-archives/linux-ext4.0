Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37850 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbeLCBXg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 20:23:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2B6B92A76D
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 01:23:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 01:23:33 +0000
Message-ID: <bug-201685-13602-E8N6ziPsta@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #176 from Theodore Tso (tytso@mit.edu) ---
Hi Sune, alas for your theory in #169, I am already using gcc 8.2.0-9 from
Debian testing.

% gcc --version
gcc (Debian 8.2.0-9) 8.2.0

Could it an Ubuntu-specific issue?   I don't think so, since there have been
some people running Debian and Gentoo who have reported the problem, and one
person who reported the problem was running Debian and was using gcc 8.2.0-9.

I have built kernels using gcc 8.2.0-9 and used them for regression testing
using gce-xfstests:

% objdump -s --section .comment /build/ext4-64/vmlinux

Contents of section .comment:
 0000 4743433a 20284465 6269616e 20382e32  GCC: (Debian 8.2
 0010 2e302d39 2920382e 322e3000           .0-9) 8.2.0. 

The kernel I am using on my personal development laptop was compiled using gcc
8.2.0-8:

% objdump -s --section .comment
/usr/lib/debug/lib/modules/4.19.0-00022-g831156939ae8/vmlinux  

Contents of section .comment:
 0000 4743433a 20284465 6269616e 20382e32  GCC: (Debian 8.2
 0010 2e302d38 2920382e 322e3000           .0-8) 8.2.0.

Of course, I'm not doing anything more exciting than running chrome, mutt,
emacs, and building kernels most of the time...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
