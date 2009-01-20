From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Tue, 20 Jan 2009 09:18:43 -0800 (PST)
Message-ID: <20090120171843.787B410800C@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022AbZATRSq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jan 2009 12:18:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0KHIhXt013867
	for <linux-ext4@vger.kernel.org>; Tue, 20 Jan 2009 09:18:44 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #9 from jack@suse.cz  2009-01-20 09:18 -------
Ted, I've looked into this and it is a bug in ext4. It should call
grab_cache_page_write_begin() with AOP_FLAG_NOFS since it cannot handle
recursion into the filesystem for freeing memory. The problem is that at the
time grab_cache_page_write_begin() is called, a transaction is already started
- this is what quota code complains about (because it also needs to start a
transaction but current->journal_info is already occupied by ext4).

If we wanted to avoid AOP_FLAG_NOFS we could get the page, start a transaction,
lock and check the page but that's going to be a bit nasty.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
