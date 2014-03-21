From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Fri, 21 Mar 2014 16:04:12 +0000
Message-ID: <bug-71641-13602-fvmXlHcchx@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaCUQEQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2014 12:04:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6592B20203
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2014 16:04:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B102E2025B
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2014 16:04:12 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

--- Comment #6 from Theodore Tso <tytso@mit.edu> ---
Could you try changing JBD2_NR_BATCH (defined in include/linux/jbd2.h) from 64
to 256?  If that improves, you can try 512, but that might not make a further
difference.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
