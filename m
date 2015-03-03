From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93491] Kernel crashes every 10 minutes. Computer stalls
Date: Tue, 03 Mar 2015 18:38:40 +0000
Message-ID: <bug-93491-13602-U8DaGhVDjC@https.bugzilla.kernel.org/>
References: <bug-93491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40883 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbbCCSio (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Mar 2015 13:38:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5BA0F203B7
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2015 18:38:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CD423203E9
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2015 18:38:40 +0000 (UTC)
In-Reply-To: <bug-93491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93491

Carlos Maiolino <cmaiolino@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cmaiolino@redhat.com

--- Comment #9 from Carlos Maiolino <cmaiolino@redhat.com> ---
Can you collect data before the reboot then?

sysrq or serial console maybe?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
