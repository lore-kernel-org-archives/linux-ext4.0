From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Fri, 25 Feb 2011 03:08:50 GMT
Message-ID: <201102250308.p1P38oNO009333@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:57119 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1BYDIu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 22:08:50 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1P38oDH009334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 25 Feb 2011 03:08:50 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #7 from Eric Whitney <eric.whitney@hp.com>  2011-02-25 03:08:48 ---
Hi Lukas:

When running the large_file_creates_threads=192 workload with this patch on an
-rc5 kernel, I consistently saw a new failure. The ext4lazyinit thread stalled
(tripping hung task detector) along with the flusher and journal threads, and
ffsb then ceased to make forward progress.

I think we're just seeing a new variant of the original race, where
bio_batch_end_io() sometimes never gets the value of &bb->done it's waiting
for:

bio_batch_end_io()
  ...
complete(bb->wait)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
