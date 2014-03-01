From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71301] CPU soft lockup
Date: Sat, 01 Mar 2014 06:53:18 +0000
Message-ID: <bug-71301-13602-tydIubB2GP@https.bugzilla.kernel.org/>
References: <bug-71301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51298 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaCAGxU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Mar 2014 01:53:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7D7D520304
	for <linux-ext4@vger.kernel.org>; Sat,  1 Mar 2014 06:53:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CBFC520225
	for <linux-ext4@vger.kernel.org>; Sat,  1 Mar 2014 06:53:18 +0000 (UTC)
In-Reply-To: <bug-71301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71301

--- Comment #2 from Cyril Adrian <cyril.adrian@gmail.com> ---
Nothing reliable, but a lot of memory retention (3.13 succeeds to fill up my
16Gb RAM, e.g. when I do a remote backup using rsync; something never seen
before) -- maybe worsened by suspend, but I'm not sure about anything.

Anyway it seems related to 3.13 because I never had any problem with 3.12.

How can I investigate?

Thanks,

Cyril

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
