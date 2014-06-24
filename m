From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19502] 'losetup -c' on a mounted loopN device with ext[34]
 causes soft lockup
Date: Tue, 24 Jun 2014 17:16:00 +0000
Message-ID: <bug-19502-13602-iOlR0HVygx@https.bugzilla.kernel.org/>
References: <bug-19502-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59261 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbaFXRQD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2014 13:16:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 65ED72035E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2014 17:16:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 23A43201EF
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2014 17:16:01 +0000 (UTC)
In-Reply-To: <bug-19502-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19502

xerofoify@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xerofoify@gmail.com

--- Comment #1 from xerofoify@gmail.com ---
This bug is against an obsolete kernel.Please test to see if fixed
with newer kernel releases.
Nick

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
