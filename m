From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 28 Oct 2009 07:20:37 GMT
Message-ID: <200910280720.n9S7Kbqa012942@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34043 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbZJ1HUc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2009 03:20:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9S7KbKB012943
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2009 07:20:37 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #139 from Brian Rogers <brian@xyzw.org>  2009-10-28 07:20:35 ---
I think he meant that it clears the journal when you do that. If that's the
case, then you can't confirm something went wrong using your method because for
all you know the journal was correct and would have repaired everything, but
now it's been cleared and fsck won't have the chance to replay it.

But yeah, if noload just leaves the journal untouched so fsck can later have a
look at it, then what you tried makes sense.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
