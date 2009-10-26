From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 26 Oct 2009 16:17:46 GMT
Message-ID: <200910261617.n9QGHkRs018150@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39743 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZJZQRl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Oct 2009 12:17:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9QGHkf7018151
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2009 16:17:46 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #118 from Eric Sandeen <sandeen@redhat.com>  2009-10-26 16:17:44 ---
Linus, are you seeing the fsck & runtime errors after a clean shutdown, or only
after a crash/reset/poweroff ?  Or both?  (we seem to potentially have reports
of both...)

Thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
