From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] ext4_mb_generate_buddy self ext4 errors
Date: Tue, 19 Nov 2013 18:21:27 +0000
Message-ID: <bug-51431-13602-vXuJUT11XQ@https.bugzilla.kernel.org/>
References: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46170 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3KSSVb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Nov 2013 13:21:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 19AA0201B9
	for <linux-ext4@vger.kernel.org>; Tue, 19 Nov 2013 18:21:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5E61320454
	for <linux-ext4@vger.kernel.org>; Tue, 19 Nov 2013 18:21:27 +0000 (UTC)
In-Reply-To: <bug-51431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |CODE_FIX

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
