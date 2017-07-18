From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 22:19:14 +0000
Message-ID: <bug-196405-13602-TaBT8m5VtJ@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47452 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751969AbdGRWTP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 18:19:15 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E6F7A28606
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 22:19:14 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #6 from Paul Eggert (eggert@cs.ucla.edu) ---
(In reply to Andreas Dilger from comment #5)
> the "link count == 1" meaning is historical for ancient filesystems ...
> it didn't mean "lots of subdirectories", but rather "I don't know the
> subdirectory count at all".

This meaning is still true for ext4. For example:

$ mkdir d d/{1..64998}
$ rm -fr d
$ mkdir d
$ ls -ld d
drwxr-xr-x 2 eggert eggert 4096 Jul 18 15:14 d
$ mkdir d/{1..64998}
$ rmdir d/*
$ ls -ld d
drwxr-xr-x 1 eggert eggert 1441792 Jul 18 15:14 d

That last link count of 1 means "I don't know the subdirectory count", even
though d has no subdirectories whatsoever.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
