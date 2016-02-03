From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111801] mount fails silently if mount point is "busy"
Date: Wed, 03 Feb 2016 15:27:53 +0000
Message-ID: <bug-111801-13602-Gg1sHe22fy@https.bugzilla.kernel.org/>
References: <bug-111801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbcBCP2B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2016 10:28:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E09B120204
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2016 15:27:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D7B4220221
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2016 15:27:53 +0000 (UTC)
In-Reply-To: <bug-111801-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111801

David Knight <diemkae@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
