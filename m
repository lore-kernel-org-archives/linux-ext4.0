From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Fri, 21 Aug 2015 14:59:51 +0000
Message-ID: <bug-103111-13602-rCALwUJLnC@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbbHUO74 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2015 10:59:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 97FE2205F4
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2015 14:59:55 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C1BB020608
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2015 14:59:51 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #6 from Eric Sandeen <sandeen@redhat.com> ---
I'll look at it when I have time...

If you want to be sure to avoid data loss, you should use data integrity
syscalls (fsync & friends): http://lwn.net/Articles/457667/

The auto-alloc heuristics are just that; if you want guarantees, call fsync.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
