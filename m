From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Fri, 25 Feb 2011 03:25:47 GMT
Message-ID: <201102250325.p1P3PlaU030888@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48261 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab1BYDZr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 22:25:47 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1P3Plpj030889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 25 Feb 2011 03:25:47 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #8 from Eric Whitney <eric.whitney@hp.com>  2011-02-25 03:25:46 ---
(sorry - network hiccup - starting from the top again)

bio_batch_end_io()                  blkdev_issue_zeroout()
  ...                                 wait_for_completion(&wait)
  complete(bb->wait)                  ...
  ...                                 issued != atomic_read(&bb.done)
  ...                                 wait_for_completion(&wait)
  atomic_inc(&bb->done)               ...
                                      <wedge while waiting for the completion
                                       that won't be coming>

At any rate, that's what I think is happening - we're missing the last "inc"
and then we're not getting the completion notification we need to finish in
blkdev_issue_zeroout().

I'll attach the first hung task trace from the console for reference.

Thanks!
Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
