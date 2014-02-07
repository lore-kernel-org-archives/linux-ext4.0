From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53951] race condition on mounting local disks with autofs
Date: Fri, 07 Feb 2014 17:58:47 +0000
Message-ID: <bug-53951-13602-lMIQW7G43P@https.bugzilla.kernel.org/>
References: <bug-53951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52628 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaBGR6u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Feb 2014 12:58:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E1CF72012B
	for <linux-ext4@vger.kernel.org>; Fri,  7 Feb 2014 17:58:48 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 38AF220114
	for <linux-ext4@vger.kernel.org>; Fri,  7 Feb 2014 17:58:48 +0000 (UTC)
In-Reply-To: <bug-53951-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=53951

Harald Dunkel <harri@afaics.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #4 from Harald Dunkel <harri@afaics.de> ---
Hi folks,

using "/misc/data6/" or a manual mount or BROWSE_MODE=no did the trick, so it
seems you are right. I will contact the autofs folks. 

Thanx very much 
Harri

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
