From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Thu, 10 Oct 2013 06:49:29 +0000
Message-ID: <bug-62751-13602-Y9GcAOiKV8@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57277 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab3JJGtb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Oct 2013 02:49:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7A10B2038C
	for <linux-ext4@vger.kernel.org>; Thu, 10 Oct 2013 06:49:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 83ECE202C3
	for <linux-ext4@vger.kernel.org>; Thu, 10 Oct 2013 06:49:29 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

--- Comment #4 from Loris Luise <loris.luise@gmail.com> ---
Update to kernel 3.11.4-generic, problem still persist, I added another attach
(bug-20131010084533.txt)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
