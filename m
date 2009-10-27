From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 20:37:32 GMT
Message-ID: <200910272037.n9RKbW4l013893@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52507 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbZJ0Uh1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 16:37:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9RKbWp8013894
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 20:37:32 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #133 from Eric Sandeen <sandeen@redhat.com>  2009-10-27 20:37:31 ---
(In reply to comment #132)

> Perhaps more strange, doing the same test on a non-root fs under 2.6.32 also
> doesn't seem to hit it reliably.  Could it be something about the remount,ro
> flush of the root fs on the way down?

er, no, that doesn't make sense in my poweroff scenario does it!  Sigh.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
