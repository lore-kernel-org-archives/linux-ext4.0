From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 19:17:40 GMT
Message-ID: <200910301917.n9UJHepO006006@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52158 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbZJ3TRf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 15:17:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9UJHeTp006007
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 19:17:40 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #158 from Eric Sandeen <sandeen@redhat.com>  2009-10-30 19:17:33 ---
Thanks Linus, yep I probably just got "lucky" and incorrectly marked a good
run.

Or, somehow the bisect between two post-.31 commits wound up with .30 in the
Makefile, and I *cough* tested the wrong kernel, not expecting the version to
move backwards.

I'm running some bisects & tests in the background to try to narrow it down
while we have our thinking caps on ... FWIW I can confirm that 2.6.32-rc3
fails.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
