From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Sun, 24 Jan 2010 19:27:35 GMT
Message-ID: <201001241927.o0OJRZe1010955@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53811 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0AXT1g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 14:27:36 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0OJRZAM010956
	for <linux-ext4@vger.kernel.org>; Sun, 24 Jan 2010 19:27:35 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #41 from carlos.velasco@nimastelecom.com  2010-01-24 19:27:33 ---
Tested with unpatched kernel and the temp files are there too. Can't test the
error unmounting / because when /tmp is unmounted it gives oops. This may be
another problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
