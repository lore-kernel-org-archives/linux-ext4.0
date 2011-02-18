From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Fri, 18 Feb 2011 21:54:17 GMT
Message-ID: <201102182154.p1ILsHL9011115@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:38784 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab1BRVyR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Feb 2011 16:54:17 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1ILsHM1011116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 18 Feb 2011 21:54:17 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #1 from Eric Whitney <eric.whitney@hp.com>  2011-02-18 21:54:16 ---
Created an attachment (id=48362)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48362)
captured console output - another back trace of a different sort

This backtrace is also from -rc5, and shows both the typical trace in softirq
as well as the cascade of faults mentioned in the description.  In this case,
we've got a failure other than spinlock bad magic reported.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
