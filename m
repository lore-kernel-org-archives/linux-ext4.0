From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Tue, 01 Apr 2014 03:32:57 +0000
Message-ID: <bug-23732-13602-ZCwHQ1MO7r@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59780 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaDADdD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 23:33:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E2286203B4
	for <linux-ext4@vger.kernel.org>; Tue,  1 Apr 2014 03:33:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6F24620380
	for <linux-ext4@vger.kernel.org>; Tue,  1 Apr 2014 03:32:59 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

--- Comment #5 from Conrad Meyer <cse.cem@gmail.com> ---
Hm, ignore my patch I guess. Some historical context:

http://thread.gmane.org/gmane.comp.file-systems.ext4/40978

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
