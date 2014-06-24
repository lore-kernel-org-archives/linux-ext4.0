From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Tue, 24 Jun 2014 18:41:38 +0000
Message-ID: <bug-61601-13602-JcUpsZvd9E@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35463 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbaFXSll (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2014 14:41:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 545832037A
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2014 18:41:40 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D461D2035C
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2014 18:41:38 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

xerofoify@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xerofoify@gmail.com

--- Comment #6 from xerofoify@gmail.com ---
Would you fine giving me a trace back on a release from the last year as 
it may be fixed. If not I would be glad to fix it.
Cheers Nick

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
