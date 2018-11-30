Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47630 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbeLAGMy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 01:12:54 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8CAE02F66A
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 19:02:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 19:02:39 +0000
Message-ID: <bug-201685-13602-lUGESz6Qkr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #99 from Guenter Roeck (linux@roeck-us.net) ---
#98: Good point.

I am going to give it a try with the following on top of v4.19.5:

Revert "ext4: handle layout changes to pinned DAX mappings"
Revert "dax: remove VM_MIXEDMAP for fsdax and device dax"
Revert "ext4: close race between direct IO and ext4_break_layouts()"
Revert "ext4: improve code readability in ext4_iget()"
Revert "ext4: readpages() should submit IO as read-ahead"

Wild shot, but I figured it may be worth try.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
