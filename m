From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 23:15:40 +0000
Message-ID: <bug-196405-13602-yO7S253Leg@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55768 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752040AbdGRXPt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 19:15:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 847CB285FD
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 23:15:49 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #8 from Paul Eggert (eggert@cs.ucla.edu) ---
(In reply to Theodore Tso from comment #1)
> In order to support a large
> number of directories, when we have a 16-bit link count field, we use
> a link count of 1 to mean, "lots".

Where is this behavior documented? I don't see it mentioned in
e2fsprogs/doc/libext2fs.texinfo. Where should I look?

> various userspace utilities that try to optimize
> directory walking by depending on the directory's link count to
> understand when they have found all of the subdirectories know that
> directory link count of 1 means "lots".

Although I've been contributing to the GNU core utilities for many years, this
behavior is news to me. I just checked the GNU coreutils source, and these
utilities do not know that 1 means "lots". Although the code happens to work,
it is pure luck. GNU findutils is similar.

The GNU C library's fts functions can misbehave on file systems where st_nlink
undercounts the number of subdirectories. To reproduce the problem, run the
program fts-test.c (attached to this bug report) in a fresh directory. On an
ext4 file system, the program outputs "0 needles found (should be 2)" and
fails, due to the incompatibility between ext4 st_nlink behavior and what the
GNU C library expects.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
