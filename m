From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Fri, 21 Aug 2015 15:16:25 +0000
Message-ID: <bug-103111-13602-1NWOs9kBgL@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46478 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbHUPQ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2015 11:16:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D7B58205DF
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2015 15:16:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1E1DF2060C
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2015 15:16:26 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #8 from Eric Sandeen <sandeen@redhat.com> ---
Yes, that's unfortunately true.
FWIW, you mention that you tested v3.14; that's still over a year old.
If you have the time, a test on latest upstream would be great.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
