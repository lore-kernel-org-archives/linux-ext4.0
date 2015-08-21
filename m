From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Fri, 21 Aug 2015 15:13:08 +0000
Message-ID: <bug-103111-13602-xC2Ydr7VuX@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46330 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbbHUPNK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2015 11:13:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 136A42044B
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2015 15:13:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 64EA52035B
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2015 15:13:08 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #7 from Rakesh <patelrakeshcomp@gmail.com> ---
Thanks Eric. I have already gone through that link and many other forums also.
fsync and fdatasync is the guaranteed solution but not all of the open-source
libraries are doing fsync.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
