From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113041] mbcache NULL pointer dereference
Date: Tue, 15 Mar 2016 02:11:55 +0000
Message-ID: <bug-113041-13602-aGJf9TRLwQ@https.bugzilla.kernel.org/>
References: <bug-113041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45916 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831AbcCOCL7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2016 22:11:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4B07C203A5
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 02:11:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E83BB20375
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 02:11:55 +0000 (UTC)
In-Reply-To: <bug-113041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113041

nickkrause@sympatico.ca changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nickkrause@sympatico.ca

--- Comment #1 from nickkrause@sympatico.ca ---
Have you tried a newer rc candidate to see if this bug has been fixed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
