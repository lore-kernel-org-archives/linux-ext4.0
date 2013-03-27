From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55651] Non-atomic short write problem with O_APPEND
Date: Wed, 27 Mar 2013 18:46:35 +0000 (UTC)
Message-ID: <20130327184635.A07D811FB3C@bugzilla.kernel.org>
References: <bug-55651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45569 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab3C0Sqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 14:46:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 608FB20272
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 18:46:37 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2F3592025A
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 18:46:36 +0000 (UTC)
In-Reply-To: <bug-55651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55651


Quentin Barnes <qbarnes@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext4                        |VFS
     Kernel Version|3.8.4                       |3.9-rc4




--- Comment #3 from Quentin Barnes <qbarnes@gmail.com>  2013-03-27 18:46:35 ---
I tracked the problem down to the specific patch a50527b1.

Since now I know the problem is not specific to ext[34], I'm
updating the ticket to be the VFS layer.  (HOWEVER, Bugzilla
won't let me change the assignee to fs_vfs@kernel-bugs.osdl.org.
Can someone do that for me?)

With the patch in place (even up to and including 3.9-rc4), the
attached test (mlt-auto.c) fails.

If I git revert a50527b1 out of 3.9-rc4, the test passes.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
