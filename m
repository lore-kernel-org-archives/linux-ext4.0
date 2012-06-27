From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15349] kernel BUG at fs/ext4/inode.c:1853!
Date: Wed, 27 Jun 2012 13:37:52 +0000 (UTC)
Message-ID: <20120627133752.5FCFF11F88D@bugzilla.kernel.org>
References: <bug-15349-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33256 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab2F0Nh4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 09:37:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 036A2202D1
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jun 2012 13:37:55 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 60ED1202B7
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jun 2012 13:37:52 +0000 (UTC)
In-Reply-To: <bug-15349-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15349


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE




--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2012-06-27 13:37:52 ---
If this is seen on modern kernels please update the bug

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
