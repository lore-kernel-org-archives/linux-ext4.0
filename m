From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Fri, 21 May 2010 06:08:15 GMT
Message-ID: <201005210608.o4L68Frk026105@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39012 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab0EUGIQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 May 2010 02:08:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4L68FcV026106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 21 May 2010 06:08:15 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #28 from Jens Axboe <axboe@kernel.dk>  2010-05-21 06:08:09 ---
Eric is spot on, that latter commit does indeed fix up that issue. The problem
is that the caller holds the umount sem when initiating the WB_SYNC_NONE
writeback, and thus it passes down ->sb_pinned == 1. But since we clear the
work state for WB_SYNC_NONE early, the caller can then drop the umount sem
before we are actually done writing out inodes.

So the fix is queued up with the original patch, when it goes upstream there
should be no warnings.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
