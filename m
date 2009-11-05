From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14452] Syscall to ftruncate hangs on ext4 + mdadm raid0
 filesystem on a file preallocated with fallocate
Date: Thu, 5 Nov 2009 14:23:56 GMT
Message-ID: <200911051423.nA5ENuCO008972@demeter.kernel.org>
References: <bug-14452-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57697 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127AbZKEOXv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 09:23:51 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA5ENucr008973
	for <linux-ext4@vger.kernel.org>; Thu, 5 Nov 2009 14:23:56 GMT
In-Reply-To: <bug-14452-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14452





--- Comment #3 from Jan Kara <jack@suse.cz>  2009-11-05 14:23:53 ---
Does this patch fix your problem?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
