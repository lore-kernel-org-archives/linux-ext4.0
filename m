From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69571] size overflow detected in function
 set_flexbg_block_bitmap
Date: Wed, 29 Jan 2014 15:00:18 +0000
Message-ID: <bug-69571-13602-Dg1Qwy4fHm@https.bugzilla.kernel.org/>
References: <bug-69571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41448 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbaA2PAZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jan 2014 10:00:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BBEBE201BA
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jan 2014 15:00:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 81C912017E
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jan 2014 15:00:18 +0000 (UTC)
In-Reply-To: <bug-69571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=69571

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Scheduler                   |ext4
           Assignee|mingo@elte.hu               |fs_ext4@kernel-bugs.osdl.or
                   |                            |g
            Product|Process Management          |File System

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
