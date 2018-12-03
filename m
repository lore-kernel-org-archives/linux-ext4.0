Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41608 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbeLCQUu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 11:20:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 28B5B2B1ED
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 16:20:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 16:20:41 +0000
Message-ID: <bug-201685-13602-0ahI3Sw8af@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #204 from Guenter Roeck (linux@roeck-us.net) ---
Another update:

Still working on a reliable reproducer. I have been able to reproduce the
problem again with v4.19.6 and the following patches reverted.

Revert "ext4: handle layout changes to pinned DAX mappings"
Revert "dax: remove VM_MIXEDMAP for fsdax and device dax"
Revert "ext4: close race between direct IO and ext4_break_layouts()"

I used a modified version of #185, running on each drive on the affected
system, plus a kernel build running in parallel.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
