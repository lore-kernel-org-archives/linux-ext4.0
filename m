From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71301] CPU soft lockup
Date: Sun, 02 Mar 2014 13:55:17 +0000
Message-ID: <bug-71301-13602-7uSQO7y8rZ@https.bugzilla.kernel.org/>
References: <bug-71301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49646 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaCBNzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Mar 2014 08:55:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0AB8420357
	for <linux-ext4@vger.kernel.org>; Sun,  2 Mar 2014 13:55:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 43D06202FE
	for <linux-ext4@vger.kernel.org>; Sun,  2 Mar 2014 13:55:17 +0000 (UTC)
In-Reply-To: <bug-71301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71301

Cyril Adrian <cyril.adrian@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #3 from Cyril Adrian <cyril.adrian@gmail.com> ---
OK, memtest86+ found the problem: faulty RAM. Bug fixed :-)

Best regards,

Cyril

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
