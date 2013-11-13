From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60121] -next and -mm: kmemleak reports 6 leaks in ext4_mount
 paths
Date: Wed, 13 Nov 2013 19:45:54 +0000
Message-ID: <bug-60121-13602-DgjFRc3jri@https.bugzilla.kernel.org/>
References: <bug-60121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41733 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab3KMTp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Nov 2013 14:45:57 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CA000207BF
	for <linux-ext4@vger.kernel.org>; Wed, 13 Nov 2013 19:45:55 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 83B6E207B8
	for <linux-ext4@vger.kernel.org>; Wed, 13 Nov 2013 19:45:54 +0000 (UTC)
In-Reply-To: <bug-60121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60121

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |CODE_FIX

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
