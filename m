From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Thu, 3 Mar 2011 18:58:17 GMT
Message-ID: <201103031858.p23IwHbV026286@demeter1.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:33020 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1CCS6k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 13:58:40 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p23IwK24026323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 3 Mar 2011 18:58:20 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #14 from Eric Whitney <eric.whitney@hp.com>  2011-03-03 18:58:15 ---
Hi Lukas:

Your "Possible fix no. 2" passed 36 hours of extended testing using the ffsb
scalability test suite on a modified 2.6.35-rc5 kernel with ext4, ext4
nojournal, and ext4 mblk filesystems.  The patch survived 135 ffsb runs where
an average of two runs were sufficient to produce the bug originally. 

I think your fix is good and ought to be submitted.  Please feel free to add my
Reported-by/Tested-by if you wish.

I'll follow up and retest once this patch makes it to mainline.

Thanks very much,
Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
