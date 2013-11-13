From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Wed, 13 Nov 2013 14:50:56 +0000
Message-ID: <bug-61601-13602-MwFZ1MwlD4@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48360 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759327Ab3KMOvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Nov 2013 09:51:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 489A22068A
	for <linux-ext4@vger.kernel.org>; Wed, 13 Nov 2013 14:51:02 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A096120681
	for <linux-ext4@vger.kernel.org>; Wed, 13 Nov 2013 14:50:56 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |NEEDINFO
                 CC|                            |alan@lxorguk.ukuu.org.uk

--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk> ---
Can you attach the errors when it fails

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
