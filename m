From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44951] renaming socket in use does not update /proc/X/fd
Date: Fri, 20 Jul 2012 16:50:40 +0000 (UTC)
Message-ID: <20120720165040.5A79411FACE@bugzilla.kernel.org>
References: <bug-44951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38272 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab2GTQup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2012 12:50:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D3F3220212
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 16:50:42 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id F28D620181
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 16:50:41 +0000 (UTC)
In-Reply-To: <bug-44951-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44951





--- Comment #2 from Wolfgang Rohdewald <wolfgang@rohdewald.de>  2012-07-20 16:50:40 ---
I also have one ext3 - and yes, ext3 behaves the same way.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
