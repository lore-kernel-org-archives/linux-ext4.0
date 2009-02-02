From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Sun,  1 Feb 2009 20:44:55 -0800 (PST)
Message-ID: <20090202044455.47102108040@picon.linux-foundation.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbZBBEp0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 23:45:26 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n124ittT017715
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 20:44:56 -0800
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603





------- Comment #15 from avery@shadypixel.com  2009-02-01 20:44 -------
Oh, you can the file descriptors for the files related to download by grepping
for 'tar.bz2'.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
