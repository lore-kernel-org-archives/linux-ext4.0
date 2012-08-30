From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44951] renaming socket in use does not update /proc/X/fd
Date: Thu, 30 Aug 2012 17:09:32 +0000 (UTC)
Message-ID: <20120830170932.5231A11FC3E@bugzilla.kernel.org>
References: <bug-44951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34505 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab2H3RJg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2012 13:09:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 75301202EA
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 17:09:35 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E02FB20305
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 17:09:32 +0000 (UTC)
In-Reply-To: <bug-44951-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44951


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |WILL_NOT_FIX




--- Comment #3 from Alan <alan@lxorguk.ukuu.org.uk>  2012-08-30 17:09:31 ---
Sockets live in their own namespace - the path to it is just a reference to the
object.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
