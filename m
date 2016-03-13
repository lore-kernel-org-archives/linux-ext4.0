From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114301] jbd2_journal_write_revoke_records
Date: Sun, 13 Mar 2016 19:35:29 +0000
Message-ID: <bug-114301-13602-ma5H37cCKf@https.bugzilla.kernel.org/>
References: <bug-114301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42708 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbcCMTfe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Mar 2016 15:35:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F02D7203AD
	for <linux-ext4@vger.kernel.org>; Sun, 13 Mar 2016 19:35:32 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 582CA203B5
	for <linux-ext4@vger.kernel.org>; Sun, 13 Mar 2016 19:35:30 +0000 (UTC)
In-Reply-To: <bug-114301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114301

Christian Kujau <lists@nerdbynature.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #1 from Christian Kujau <lists@nerdbynature.de> ---
Setting this to "high" won't help much :-) Was this error reported to the ext4
mailing list? What happened before this error? Was the system under load? Can
you reproduce this crash? With a current kernel?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
