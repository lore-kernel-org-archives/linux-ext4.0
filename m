From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Wed, 03 Aug 2016 03:14:16 +0000
Message-ID: <bug-76261-13602-dK844G4if3@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56720 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbcHCDOT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2016 23:14:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8F26C203A1
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2016 03:14:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 72B2D20389
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2016 03:14:16 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #18 from kun.chen <kun.chen@mediatek.com> ---
Finally my customer defer this issue, so I don't have platform to collect the
debug info anymore

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
