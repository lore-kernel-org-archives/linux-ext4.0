From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Wed, 11 Nov 2015 10:28:17 +0000
Message-ID: <bug-107301-13602-24oRE9bNvY@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47446 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbbKKK2U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2015 05:28:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5576B205BA
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 10:28:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A74F0204AF
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 10:28:17 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #15 from Jan Kara <jack@suse.cz> ---
So I guess there are two separate issues:
1) mbcache scales poorly - that is worth addressing regardless of whether ceph
/ lustre really need it or not since as you mention there are cases where
mbcache helps and scalability is an issue.
2) some usecases do not benefit from mbache much (or at all) and so we could
possibly have a heuristic to disable mbcache altogether.

My current feeling is that if mbcache is implemented properly, then the
overhead of it is a hash-table insertion / deletion when creating / removing
xattr and that should be pretty cheap compared to all the other work we do to
create external xattr (although cache line contention could be an issue here to
some degree).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
