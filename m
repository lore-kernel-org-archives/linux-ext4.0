From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12679] 2.6.28.4 ext4 fs hang, load 22 and up, may be firefox/apps stuck on sync_page
Date: Thu, 26 Feb 2009 03:10:59 -0800 (PST)
Message-ID: <20090226111059.86519108040@picon.linux-foundation.org>
References: <bug-12679-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbZBZLLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 06:11:03 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1QBAx8u013686
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 03:11:00 -0800
In-Reply-To: <bug-12679-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12679





------- Comment #6 from sec@dschroeder.info  2009-02-26 03:10 -------
Created an attachment (id=20372)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20372&action=view)
echo w > /proc/sysrq_trigger


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
