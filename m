From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 17:51:11 +0000
Message-ID: <bug-186551-13602-CBxJSmt3ro@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbcKARvP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 13:51:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3815820451
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:51:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 76FF72044C
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:51:11 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #4 from Eric Sandeen <sandeen@sandeen.net> ---
I am pretty sure all of those messages will be in 512-byte sectors.

/proc/partitions is in 1k units (just to keep it interesting)

781412184 * 1024/512 = 1562824368 512-byte sectors - also past the sector it's
trying to discard.

I wonder what happens if you try a blkdiscard for the entire device, and see if
you get a failure from it as well.  (*** note that this will clear any data on
the device, as it will discard every block on the device ***).

It seems unlikely that this is an ext4/e2fsprogs problem at this point.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
