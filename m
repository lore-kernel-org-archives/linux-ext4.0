From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Fri, 21 Mar 2014 08:44:39 +0000
Message-ID: <bug-71641-13602-Vxn0pwk2ew@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49910 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbaCUIol (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2014 04:44:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AD899202B4
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2014 08:44:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 688492028D
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2014 08:44:39 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

Chia-Hung Chang <fredchang.tc@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|CODE_FIX                    |---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
