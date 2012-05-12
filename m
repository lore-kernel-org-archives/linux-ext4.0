From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18372] A filled up named pipe always has a size of zero!
Date: Sat, 12 May 2012 15:46:53 +0000 (UTC)
Message-ID: <20120512154653.37D6B11FCE2@bugzilla.kernel.org>
References: <bug-18372-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57113 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab2ELPq4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 May 2012 11:46:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E279D203B5
	for <linux-ext4@vger.kernel.org>; Sat, 12 May 2012 15:46:54 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 3AE67203A5
	for <linux-ext4@vger.kernel.org>; Sat, 12 May 2012 15:46:53 +0000 (UTC)
In-Reply-To: <bug-18372-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=18372


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |WILL_NOT_FIX




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-05-12 15:46:52 ---
Not a bug - its the correct behaviour as per spec.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
