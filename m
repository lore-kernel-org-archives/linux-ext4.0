From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12018] oops when using ext4 on soft raid on IA64 with 65536 block size
Date: Sat, 17 Jan 2009 18:25:52 -0800 (PST)
Message-ID: <20090118022552.BDBDF10800D@picon.linux-foundation.org>
References: <bug-12018-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbZARCZy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 21:25:54 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0I2PqDX025330
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 18:25:53 -0800
In-Reply-To: <bug-12018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12018


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #2 from tytso@mit.edu  2009-01-17 18:25 -------
This patch has been committed into the the mainline kernel as of 2.6.29-rc1.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
