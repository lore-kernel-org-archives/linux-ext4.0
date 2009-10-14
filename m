From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 14 Oct 2009 03:26:24 GMT
Message-ID: <200910140326.n9E3QO9b005026@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54233 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZJND1A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 23:27:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9E3QOp8005027
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 03:26:24 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #45 from Holger Freyther <zecke@selfish.org>  2009-10-14 03:26:23 ---
My idea for reproducing this would be:

$ rm -rf *
$ git checkout .
$ make


and then power cycle/reset during the make. I will report later on this.

One other question (and I'm not familiar with extX code at all). If the
hypothesis would be that the allocated bitmap is corrupted. From where can this
happen?

     - In memory bitmap not written out, journal not claiming these blocks,
reassigning them during runtime?
       This would be a journal bug?

     - Block allocation at runtime forgetting to update the bit and block
allocation assigning the same block again?
       This would sound like a missing lock somewhere?

     - delayed allocation picking the same block?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
