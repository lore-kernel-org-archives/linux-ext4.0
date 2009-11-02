From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 2 Nov 2009 23:11:02 GMT
Message-ID: <200911022311.nA2NB2OG001728@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58706 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbZKBXK7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2009 18:10:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA2NB3PE001729
	for <linux-ext4@vger.kernel.org>; Mon, 2 Nov 2009 23:11:03 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #168 from Eric Sandeen <sandeen@redhat.com>  2009-11-02 23:10:53 ---
if the folks who saw this could revert d0646f7b636d067d715fab52a2ba9c6f0f46b0d7
(or just pull Linus' git tree, because he's reverted it upstream) and retest
your scenarios that'd be great.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
