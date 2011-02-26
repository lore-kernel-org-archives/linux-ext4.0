From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Sat, 26 Feb 2011 03:50:15 GMT
Message-ID: <201102260350.p1Q3oFmj002907@demeter1.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:57851 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1BZDuR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 22:50:17 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1Q3oFBq002908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 03:50:16 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #10 from Eric Whitney <eric.whitney@hp.com>  2011-02-26 03:50:09 ---
Created an attachment (id=49172)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=49172)
Possible fix - patch simplifies completion counting and avoids races

Hi Lukas:

This patch has successfully passed an initial round of tests which 2.6.38-rc*
kernels have never passed.  It seemed appropriate to simplify the way
outstanding completions were being accounted for to avoid the races, and the
code ought to be just a little more efficient on a SMP/NUMA box as well.  At
any rate, it's a stab at it - I'd appreciate any comments you might have.  I'll
put it through a weekend's worth of test runs next.

Thanks!
Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
