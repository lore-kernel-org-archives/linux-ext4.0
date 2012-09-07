From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Fri,  7 Sep 2012 18:07:02 +0000 (UTC)
Message-ID: <20120907180702.B9D8F11FC25@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46882 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab2IGSHF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Sep 2012 14:07:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7A9F520438
	for <linux-ext4@vger.kernel.org>; Fri,  7 Sep 2012 18:07:04 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BE0512043D
	for <linux-ext4@vger.kernel.org>; Fri,  7 Sep 2012 18:07:02 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #3 from Elmar Stellnberger <estellnb@elstel.org>  2012-09-07 18:07:02 ---
i.e. only allow a small part of the memory to hold 4KB fragments. In worst case
we would fall down to an effective emulated page size of 8KB.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
