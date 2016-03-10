From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114301] jbd2_journal_write_revoke_records Oops: Kernel access
 of bad area
Date: Thu, 10 Mar 2016 13:47:15 +0000
Message-ID: <bug-114301-13602-PvyONU5Hah@https.bugzilla.kernel.org/>
References: <bug-114301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbcCJNrY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Mar 2016 08:47:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DB31A200F0
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2016 13:47:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5D05020377
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2016 13:47:15 +0000 (UTC)
In-Reply-To: <bug-114301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114301

xierui1010@sina.com.cn changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|"Oops: Kernel access of bad |jbd2_journal_write_revoke_r
                   |area, sig: 11 [#1]" (check  |ecords Oops: Kernel access
                   |log for details)            |of bad area

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
