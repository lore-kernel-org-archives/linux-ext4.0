From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Wed, 19 Jul 2017 19:44:49 +0000
Message-ID: <bug-196405-13602-nIVYH7CkIE@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49624 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933237AbdGSTov (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 15:44:51 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B7C1426D05
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 19:44:50 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #12 from Paul Eggert (eggert@cs.ucla.edu) ---
(In reply to Theodore Tso from comment #1)
> If you don't want this behavior because strict POSIX compliance is
> preferable to failing with ENOSPC when you hit that overflow
> condition, you can create the file system with the dir_nlink feature
> turned off.

POSIX says that mkdir should fail with EMLINK if the link count in the parent
directory would exceed LINK_MAX. If the POSIX-compliant mode is setting
errno==ENOSPC then that sounds like a bug; it should fail with errno==EMLINK.

Although the documentation for tune2fs says that dir_nlink can be cleared in an
existing ext4 filesystem, this did not work for me on Fedora 26 x86-64. I
unmounted the filesystem, ran "tune2fs -O ^dir_nlink /dev/sda2", remounted the
filesystem, and verified that dir_nlink was turned off by running "dumpe2fs -h
/dev/sda2". The fts-test.c program attached to this bug report still failed in
the same way. Either this is a filesystem bug that should be fixed, or the
documentation should be changed so that it does not incorrectly say that
tune2fs can usefully change the dir_nlink option.

I then created a new ext4 file system with dir_nlink disabled from birth. Here,
the test program failed in mkdir ("d/32757", 0777) with ENOSPC. Yet there was
plenty of space in the file system, and the link count was only 32758, which is
way lower than LINK_MAX (which is 65000). Presumably the ext4 code arbitrarily
limits the link count to 32758 (i.e., to 2**15 - 10) when dir_nlink is clear.
This sounds like a bug; the limit should be 65000.

One more thing. In the typical case where dir_nlink is set, there is an
off-by-one error, as LINK_MAX is 65000 and in fts-test.c the link count should
be 65000 so this should work. That is, the link count should wrap around to 1
when it would otherwise reach 65001, not when it would otherwise reach 65000.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
