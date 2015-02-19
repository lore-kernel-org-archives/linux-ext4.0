From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19502] 'losetup -c' on a mounted loopN device with ext[34]
 causes soft lockup
Date: Thu, 19 Feb 2015 15:57:26 +0000
Message-ID: <bug-19502-13602-VWLs0ceO6Q@https.bugzilla.kernel.org/>
References: <bug-19502-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42295 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbbBSP53 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 10:57:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2836F20274
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 15:57:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7D8A020219
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 15:57:26 +0000 (UTC)
In-Reply-To: <bug-19502-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19502

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |OBSOLETE

--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk> ---
This bug relates to a very old kernel. Closing as obsolete.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
