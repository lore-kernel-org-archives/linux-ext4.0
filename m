From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 03:32:40 +0000
Message-ID: <bug-76261-13602-CKzsQ2rJK3@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54708 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbaEPDcu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 23:32:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E72C220398
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:32:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 16B082038D
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:32:41 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #3 from kun.chen <kun.chen@mediatek.com> ---
And if not used echo u > /proc/sysrq-trigger, what's the better solution?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
