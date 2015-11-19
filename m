From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Thu, 19 Nov 2015 00:49:16 +0000
Message-ID: <bug-107301-13602-xu5UCPAH3c@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43863 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbbKSAtU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Nov 2015 19:49:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9A0752047C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2015 00:49:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8D89920490
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2015 00:49:16 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #19 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca> ---
Jan, your example is a red herring, because the removal of mbcache at most
affects the performance and space efficiency, not correctness. 

I agree that making mbcache more efficient is a good goal, but I don't think
that ot should block the landing of this patch. Rather, it makes sense to land
the patch and we can still fix mbcache performance if anyone actually wants to
use it. It will also serve as the basis for any heuristic to turn mbcache on
and off dynamically instead of (or in addition to) the mount option.

Laurent, I'd be greatful if you pushed the patch upstream for the latest kernel
as I'm traveling this week.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
