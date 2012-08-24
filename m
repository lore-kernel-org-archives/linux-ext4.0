From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45941] BUG: soft lockup - CPU#1 stuck for 21s! [kworker/1:1:64]
 BUG: soft lockup - CPU#4 stuck for 22s! [flush-252:0:384]
Date: Fri, 24 Aug 2012 10:05:12 +0000 (UTC)
Message-ID: <20120824100512.C818411FC6D@bugzilla.kernel.org>
References: <bug-45941-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49688 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab2HXKFS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Aug 2012 06:05:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9FDAB2036B
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 10:05:14 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BEAD020353
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 10:05:13 +0000 (UTC)
In-Reply-To: <bug-45941-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45941





--- Comment #3 from Loris Luise <loris.luise@gmail.com>  2012-08-24 10:05:12 ---
I made 2 modifications on the server running linux and currently no more soft
lockup has happened

1) removed irqbalance daemon from ubuntu server
2) unchecked "Synchronize guest time with host" from VM setting (VMWare esx)

Modification 1) most probably solved the problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
