From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12679] 2.6.28.4 ext4 fs hang, load 22 and up, may be firefox/apps stuck on sync_page
Date: Mon,  9 Feb 2009 07:59:43 -0800 (PST)
Message-ID: <20090209155943.94C5E108041@picon.linux-foundation.org>
References: <bug-12679-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbZBIQAO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 11:00:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n19FxioP025384
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 07:59:45 -0800
In-Reply-To: <bug-12679-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12679





------- Comment #1 from sec@dschroeder.info  2009-02-09 07:59 -------
Created an attachment (id=20168)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20168&action=view)
ps -wweo uid,pid,ppid,pri,wchan:20,stat,time,command

fetchmail is an example of application, which was started, after the filesystem
went faulty...


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
