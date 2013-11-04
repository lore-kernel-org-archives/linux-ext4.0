From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Mon, 04 Nov 2013 11:53:01 +0000
Message-ID: <bug-62751-13602-v8iI8NrTkb@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54347 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3KDLxF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Nov 2013 06:53:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8AA6A20554
	for <linux-ext4@vger.kernel.org>; Mon,  4 Nov 2013 11:53:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5C30E2054D
	for <linux-ext4@vger.kernel.org>; Mon,  4 Nov 2013 11:53:01 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|3.11.6-031106-generic       |3.11.6

--- Comment #7 from Alan <alan@lxorguk.ukuu.org.uk> ---
Jan - its on a vmware virtual platform so it could just be that vmware ran off
with the CPU. Can you duplicate this on a native platform, and if you disable
the NMI watchdog does the kernel hang or merely stall for a moment in this
situation ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
