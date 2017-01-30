From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193431] 512 byte inodes + inline_data + journal_data ==
 segfaults/buserrors in userspace mmap
Date: Mon, 30 Jan 2017 02:56:18 +0000
Message-ID: <bug-193431-13602-0xyb0PYya5@https.bugzilla.kernel.org/>
References: <bug-193431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdA3DEb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Jan 2017 22:04:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 91D08202EC
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 02:56:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 025A5202C8
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 02:56:19 +0000 (UTC)
In-Reply-To: <bug-193431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193431

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |INVALID

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
Using a stock ext4 file system ---- or an xfs file system --- results in the
same segfault in localdef.

So I think Christian is right.  This has nothing to do with ext4.

P.S.  I just tried with btrfs, and surprise!   localdef is also crashing with a
segfault.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
