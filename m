From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12679] 2.6.28.4 ext4 fs hang, load 22 and up, may be firefox/apps stuck on sync_page
Date: Tue, 10 Feb 2009 11:43:27 -0800 (PST)
Message-ID: <20090210194327.2B079108041@picon.linux-foundation.org>
References: <bug-12679-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbZBJTns (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 14:43:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1AJhRr5021176
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2009 11:43:28 -0800
In-Reply-To: <bug-12679-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12679





------- Comment #3 from sec@dschroeder.info  2009-02-10 11:43 -------
compiled kernel with magic sysrq and waiting for reoccurrence...
timeline:
switched to ext4
happened once
happened twice (wrote this entry)
waiting...


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
