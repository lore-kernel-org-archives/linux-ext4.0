From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39732] JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr
 = 2512725). There's a risk of filesystem corruption in case of system crash.
Date: Mon,  2 Jul 2012 13:53:27 +0000 (UTC)
Message-ID: <20120702135327.908E111FA5D@bugzilla.kernel.org>
References: <bug-39732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49299 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab2GBNxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 09:53:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E463020259
	for <linux-ext4@vger.kernel.org>; Mon,  2 Jul 2012 13:53:32 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 926D120255
	for <linux-ext4@vger.kernel.org>; Mon,  2 Jul 2012 13:53:27 +0000 (UTC)
In-Reply-To: <bug-39732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39732


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
