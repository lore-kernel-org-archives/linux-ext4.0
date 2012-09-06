From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45441] kernel BUG at
 /build/buildd/linux-3.2.0/fs/jbd2/transaction.c:1093!
Date: Thu,  6 Sep 2012 15:47:55 +0000 (UTC)
Message-ID: <20120906154755.7454011FC25@bugzilla.kernel.org>
References: <bug-45441-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33026 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503Ab2IFPr6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Sep 2012 11:47:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 15009204E3
	for <linux-ext4@vger.kernel.org>; Thu,  6 Sep 2012 15:47:57 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7815820458
	for <linux-ext4@vger.kernel.org>; Thu,  6 Sep 2012 15:47:55 +0000 (UTC)
In-Reply-To: <bug-45441-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45441


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |ext4
         AssignedTo|other_other@kernel-bugs.osd |fs_ext4@kernel-bugs.osdl.or
                   |l.org                       |g
            Product|Other                       |File System




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
