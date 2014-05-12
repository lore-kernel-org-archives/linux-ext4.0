From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 75881] lazyinit failure on new mdadm raid5 & encrypted array
Date: Mon, 12 May 2014 05:09:13 +0000
Message-ID: <bug-75881-13602-l9Jq6meC7r@https.bugzilla.kernel.org/>
References: <bug-75881-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaELFJP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 01:09:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6A15B2020F
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2014 05:09:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AF3D120179
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2014 05:09:13 +0000 (UTC)
In-Reply-To: <bug-75881-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=75881

--- Comment #2 from TR Reardon <thomas_reardon@hotmail.com> ---
I cannot reproduce.  A quick glance at the stack made me fear that this was not
an obvious ext4 problem but an interaction bug between block layers.  Still
thought I should submit in case it proved useful...hard to easily repro errors
building 16TB arrays on production servers

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
