From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Thu, 31 Mar 2016 13:53:44 +0000
Message-ID: <bug-107301-13602-ZmkiSRF3Z3@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55771 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbcCaNxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Mar 2016 09:53:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7401C2026C
	for <linux-ext4@vger.kernel.org>; Thu, 31 Mar 2016 13:53:48 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C132F20251
	for <linux-ext4@vger.kernel.org>; Thu, 31 Mar 2016 13:53:44 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

Erwan Velu <erwan@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |erwan@redhat.com

--- Comment #23 from Erwan Velu <erwan@redhat.com> ---
I'm making a short review on that issue that Ceph user could trigger.

Regarding the current state, it seems that Jan got his work to be present in
the 4.6.x series.

Laurent, Medhi, could you make a try with Jan's patch to confirm that its ok
for you too ?

Testing the 4.6-rc1 would be ideal as we could tell Ceph's users then that 4.6
is fixing the issue you had.

Thanks,

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
