From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53951] race condition on mounting local disks with autofs
Date: Wed, 05 Feb 2014 17:03:53 +0000
Message-ID: <bug-53951-13602-54xc3ri31k@https.bugzilla.kernel.org/>
References: <bug-53951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59846 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaBERD5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 12:03:57 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3575C2010B
	for <linux-ext4@vger.kernel.org>; Wed,  5 Feb 2014 17:03:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5DB3C20127
	for <linux-ext4@vger.kernel.org>; Wed,  5 Feb 2014 17:03:54 +0000 (UTC)
In-Reply-To: <bug-53951-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=53951

--- Comment #1 from Harald Dunkel <harri@afaics.de> ---
This problem is still in (using 3.12.8):

% find /misc/data6 | wc -l; find /misc/data6 | wc -l
17
find: `/misc/data6/lost+found': Permission denied
341

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
