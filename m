From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16380] ext2/ext4 filesystem "hangs" for a few seconds when
 trying to write a lot of data to a freshly RW mounted FS
Date: Sat,  4 Aug 2012 12:54:40 +0000 (UTC)
Message-ID: <20120804125440.C944811FC62@bugzilla.kernel.org>
References: <bug-16380-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41463 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2HDMyn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2012 08:54:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F1C820238
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 12:54:42 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 42B272022B
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 12:54:41 +0000 (UTC)
In-Reply-To: <bug-16380-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16380


Artem S. Tashkinov <t.artem@mailcity.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|2.6.35                      |2.6.x 3.x
         Regression|Yes                         |No




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
