From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 10 Oct 2009 16:50:59 GMT
Message-ID: <200910101650.n9AGoxpt025177@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44475 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZJJQvf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Oct 2009 12:51:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9AGoxeb025178
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2009 16:50:59 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #7 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-10 16:50:59 ---
the guestion is why fsck think the partition is clean if it use 2.6.32 and if
you force fsck on 2.6.31 it will "fix" it even ther was new files on broken
bloks?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
