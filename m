From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11756] Incorrect file remove from ext4
Date: Thu,  6 Nov 2008 12:50:31 -0800 (PST)
Message-ID: <20081106205031.C6432108040@picon.linux-foundation.org>
References: <bug-11756-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYKFUvE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 15:51:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA6KoV5d003814
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 12:50:32 -0800
In-Reply-To: <bug-11756-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11756


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #5 from tytso@mit.edu  2008-11-06 12:50 -------
This bug is fixed in 2.6.28-rc2, commit ID 3c37fc86d20


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
