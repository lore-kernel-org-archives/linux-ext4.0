From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44951] renaming socket in use does not update /proc/X/fd
Date: Fri, 20 Jul 2012 16:08:01 +0000 (UTC)
Message-ID: <20120720160801.6724A11FB04@bugzilla.kernel.org>
References: <bug-44951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37231 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2GTQII (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2012 12:08:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4FD102020C
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 16:08:03 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 150CF2019B
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 16:08:02 +0000 (UTC)
In-Reply-To: <bug-44951-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44951


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2012-07-20 16:08:01 ---
(In reply to comment #0)

> using ext4 of course

I doubt that this is unique to ext4, is it?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
