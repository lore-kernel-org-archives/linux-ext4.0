From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Tue, 22 Feb 2011 04:10:34 GMT
Message-ID: <201102220410.p1M4AYr4019669@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:53997 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1BVEKf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 23:10:35 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1M4AY83019670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 04:10:34 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #3 from Eric Whitney <eric.whitney@hp.com>  2011-02-22 04:10:33 ---
Hi, Lukas:

Unfortunately, I omitted the argument, and that's what's confusing you.   I'm
saying that it works fine - no panic - with the feature disabled:  -E
lazy_itable_init=0.  (I'm sorry about that.  I was filing just a little too
quickly after informing Ted via IRC.  It's been a long hunt.)  Again, it panics
easily with lazy_itable_init set to its default, which means without using the
switch.

In addition to what I initially reported, I've made more than 80 additional
ffsb runs on freshly made ext4, ext4 nojournal, and ext4 mblk_io_submit
filesystems over the last three days with lazy_itable_init=0, and there have
been no further panics.

For the record, I'm using e2fsprogs 1.41.14 straight from Ted's git tree.

Thanks,
Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
