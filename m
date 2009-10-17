From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 08:18:10 GMT
Message-ID: <200910170818.n9H8IAw2023803@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58753 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZJQISH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 04:18:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9H8IAFa023804
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 08:18:10 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #77 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-17 08:18:09 ---
i tested 2.6.30, nothing in fsck.log or dmesg, md5sum found 6 corrupted files.
I assume  corruted files is not a bug :) and begin to bisect lost files between
2.6.31 and 2.6.32-rc4

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
