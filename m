From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] ext4 without journal reproductible file corruption
Date: Wed, 20 May 2009 17:36:26 GMT
Message-ID: <200905201736.n4KHaQa9020988@demeter.kernel.org>
References: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45793 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZETRgZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 13:36:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4KHaQP2020989
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2009 17:36:26 GMT
In-Reply-To: <bug-13292-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13292





--- Comment #5 from Frank Mayhar <fmayhar@google.com>  2009-05-20 17:36:26 ---
Just FYI, as I said I was unable to reproduce this in our current environment. 
We'll shortly be pulling in another set of patches from the ext4 stable tree
(bringing us from March to whatever is current at the time), at which point
I'll try again.  If I'm successful I'll do a bisection to figure out which
patch or patches introduced the problem.

Assuming Ted doesn't beat me to it, anyway. :-)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
