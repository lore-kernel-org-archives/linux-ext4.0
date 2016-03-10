From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114301] jbd2_journal_write_revoke_records
Date: Thu, 10 Mar 2016 13:47:57 +0000
Message-ID: <bug-114301-13602-Gm7IrEuVsm@https.bugzilla.kernel.org/>
References: <bug-114301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbcCJNsE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Mar 2016 08:48:04 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A37E120377
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2016 13:47:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1796320364
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2016 13:47:58 +0000 (UTC)
In-Reply-To: <bug-114301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114301

xierui1010@sina.com.cn changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|jbd2_journal_write_revoke_r |jbd2_journal_write_revoke_r
                   |ecords Oops: Kernel access  |ecords
                   |of bad area                 |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
