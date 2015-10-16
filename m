From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 16 Oct 2015 13:04:10 +0000
Message-ID: <bug-102731-13602-mFpENLrRfl@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52725 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbbJPNEN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2015 09:04:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A248220A72
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 13:04:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A4E0420A6D
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 13:04:10 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #23 from John Hughes <john@calva.com> ---
So I've booted the guest with kernel 4.3.2:

Linux olympic 4.2.3-jh1 #2 SMP Thu Oct 15 19:04:09 CEST 2015 x86_64 GNU/Linux

I'm leaving the host on debians 3.16.5-1~bpo70+1 kernel for the moment.

If I see the problem again I'll move the host to 4.2.3.

If I see the problem with host and guest at 4.2.3 I'll convert the filesystems
(in place) to ext4.

If I see the problems with in-place converted ext4 I'll rebuild the filesysems
as native ext4 and copy all the files over.

Seems like a good plan?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
