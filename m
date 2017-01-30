From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193431] inline_data + journal_data == segfaults/buserrors in
 userspace mmap
Date: Mon, 30 Jan 2017 16:07:04 +0000
Message-ID: <bug-193431-13602-UJQM9TIAuk@https.bugzilla.kernel.org/>
References: <bug-193431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932130AbdA3QHI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 11:07:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D34EA2026C
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:07:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 7594720279
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:07:04 +0000 (UTC)
In-Reply-To: <bug-193431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193431

Peter Rabbitson <rabbit@rabbit.us> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|INVALID                     |INSUFFICIENT_DATA

--- Comment #5 from Peter Rabbitson <rabbit@rabbit.us> ---
But it *is* ext4 specific - in
https://bugzilla.kernel.org/show_bug.cgi?id=193431#c3 I repeatably demonstrate
different behavior of a chroot depending solely on whether a fs is mounted with
data=journal or without. That is with a userspace that is as new as it gets (
debian stretch-to-be ).

In the coming days I will try to distill this down further to a standalone
program, but the chance is high I will fail: my C-fu is virtually nonexistent.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
