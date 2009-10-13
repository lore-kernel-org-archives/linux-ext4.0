From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 13 Oct 2009 15:12:05 GMT
Message-ID: <200910131512.n9DFC51T025318@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43591 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZJMPMm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 11:12:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9DFC5MH025319
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 15:12:05 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #35 from Alasdair G Kergon <agk@redhat.com>  2009-10-13 15:12:04 ---
We used to issue EOPNOTSUPP in response to barriers (so flushing ceased to be
supported when it became barrier-based). 'Basic' barrier support was added
first (2.6.30-rc2), as Mike says, by waiting for relevant I/O to complete. 
Then this was extended (2.6.31-rc1) to send barriers to the underlying devices
for most dm types of dm targets.

To see which dm targets in a particular source tree forward barriers run:
  grep 'ti->num_flush_requests =' drivers/md/dm*c
(set to a non-zero value).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
