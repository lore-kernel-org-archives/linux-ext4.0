From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Tue, 10 Dec 2013 22:21:20 +0000
Message-ID: <bug-20902-13602-uqjuLOk5H6@https.bugzilla.kernel.org/>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47368 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3LJWVX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 17:21:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 49806206BB
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 22:21:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8A938206AF
	for <linux-ext4@vger.kernel.org>; Tue, 10 Dec 2013 22:21:20 +0000 (UTC)
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |OBSOLETE

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
