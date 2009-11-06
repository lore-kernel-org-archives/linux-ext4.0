From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 6 Nov 2009 22:15:18 GMT
Message-ID: <200911062215.nA6MFIpT016161@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48087 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723AbZKFWPM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 17:15:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA6MFI8X016162
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 22:15:18 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #179 from Eric Sandeen <sandeen@redhat.com>  2009-11-06 22:15:16 ---
(In reply to comment #178)


> For ext4, one thing I would suggest is to simply always put the NUL at the 
> end of the name, even if the filesystem might not need it. Then 
> nd_terminate_link() will still write the NUL, but it won't change any data 
> (and thus no CRC's).

Ah, good idea in the short term at least.

FWIW I've got the other 2 places I hit fixed up and my testcase is surviving
thus far.  I'll find a testcase for the symlink, fix that up, and get some
patches out.

Big kudos to Chris for the swanky patch to make this all obvious...

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
