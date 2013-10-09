From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Wed, 09 Oct 2013 15:10:37 +0000
Message-ID: <bug-62751-13602-vBdld7TpjJ@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab3JIPKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Oct 2013 11:10:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 18A5420260
	for <linux-ext4@vger.kernel.org>; Wed,  9 Oct 2013 15:10:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 25E4220250
	for <linux-ext4@vger.kernel.org>; Wed,  9 Oct 2013 15:10:38 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

--- Comment #2 from Loris Luise <loris.luise@gmail.com> ---
Sorry, but I have not idea which part of kernel this bug is related,

so I chose ext4 (becaise in call trace I saw ext4_es_shrink+0xc8/0x140)

I logged several of this almost every day.

Kernel is running on a VMware Esxi 4.1 last patched Host on a HP ML350 G5
server.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
