From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] jbd2 write on disk each 2/3 seconds
Date: Sun, 25 May 2014 09:13:45 +0000
Message-ID: <bug-76821-13602-wBCp4P8XNX@https.bugzilla.kernel.org/>
References: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53540 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaEYJNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 May 2014 05:13:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EA95F202B8
	for <linux-ext4@vger.kernel.org>; Sun, 25 May 2014 09:13:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 514592026F
	for <linux-ext4@vger.kernel.org>; Sun, 25 May 2014 09:13:46 +0000 (UTC)
In-Reply-To: <bug-76821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76821

--- Comment #4 from Abdelhak Bougouffa <abdelhak@cryptolab.net> ---
I observed also that all the journal files are binary files and the total size
of /var/log/journal directory is 2.0GB O.o ... so what can I do!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
