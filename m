From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Fri, 28 Aug 2015 16:49:38 +0000
Message-ID: <bug-103111-13602-rtpQJsy0CT@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57624 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbbH1Qtl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2015 12:49:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6C72820991
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2015 16:49:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DE1C12099C
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2015 16:49:38 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #12 from Rakesh <patelrakeshcomp@gmail.com> ---
Ok Eric. Got it. It looks like there is only way to do fsync and/or do
truc/rename call.

So file system is working as expected.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
