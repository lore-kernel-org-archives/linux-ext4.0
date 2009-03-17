From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Mon, 16 Mar 2009 23:07:53 -0700 (PDT)
Message-ID: <20090317060753.7C190108045@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165AbZCQGI2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 02:08:28 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2H67r2m011355
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 23:08:26 -0700
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #19 from lucent+lkml@gmail.com  2009-03-16 23:07 -------
Created an attachment (id=20562)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20562&action=view)
output of debugfs 'stat <2491101>' (split 2 of 2)

Having first applied the suggested patch, is debugfs output taken after file
completed and verified intact from BitTorrent download. Split and then
compressed to comply with 1000k bugzilla constraint: 2 of 2.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
