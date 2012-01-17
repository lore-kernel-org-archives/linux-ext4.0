From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40512] EXT4_IOC_MIGRATE is dangerous on directories
Date: Tue, 17 Jan 2012 14:10:10 GMT
Message-ID: <201201171410.q0HEAAFS005237@bugzilla.kernel.org>
References: <bug-40512-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:46567 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2AQOKL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jan 2012 09:10:11 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0HEAAiu005238
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jan 2012 14:10:10 GMT
In-Reply-To: <bug-40512-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40512


Benjamin Peterson <benjamin@python.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #3 from Benjamin Peterson <benjamin@python.org>  2012-01-17 14:10:10 ---
Indeed, it is now fixed. Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
