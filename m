Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53732 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbeKHVTH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2018 16:19:07 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0E1762C4B7
        for <linux-ext4@vger.kernel.org>; Thu,  8 Nov 2018 11:44:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 08 Nov 2018 11:44:00 +0000
Message-ID: <bug-201631-13602-Lfr3muFSVm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #3 from erhard_f@mailbox.org ---
(In reply to Theodore Tso from comment #2)
> Can you reproduce this?

I will continue to run 4.20-rc kernels and report back if this occurs again. It
has not popped up on 4.19.x on my ppc machines so far.

> And you may also want to send a report to linux-mm@kvack.org, since although
> it was tripped in ext4_set_page_dirty, the WARN_ON check which is it doing
> are fundamentally page specific, so this may very well be an mm problem:
> [...]

Done.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
