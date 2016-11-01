From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 19:14:59 +0000
Message-ID: <bug-186551-13602-fpOGhc5xrT@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbcKATPE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 15:15:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 6EE8B20451
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:15:02 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 4F9122042B
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 19:15:00 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #6 from Eric Sandeen <sandeen@sandeen.net> ---
Well - I'm afraid that all I can tell you is that it's not an ext4 or e2fsprogs
problem, then.  Issuing discards straight to the device yielded those errors
with no filesystem code involved.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
