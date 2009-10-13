From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 13 Oct 2009 08:47:54 GMT
Message-ID: <200910130847.n9D8ls1j015150@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34110 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbZJMIsc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 04:48:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9D8lsK7015151
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 08:47:54 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #32 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-13 08:47:44 ---
Created an attachment (id=23378)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23378)
dmesg hoost=mini v2.6.31

This ist my laptop. I do not use here any "dm" (no raid, lvm or crypt). here i
had same issue. I used most version betveen 2.6.31 and 2.6.31-rc2 (bisction).
After reinstall there is only 2.6.31 kernel.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
