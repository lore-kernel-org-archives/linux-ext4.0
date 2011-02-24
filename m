From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29752] Possible i_nlink race in ext2_rename
Date: Thu, 24 Feb 2011 06:03:21 GMT
Message-ID: <201102240603.p1O63LFa001007@demeter2.kernel.org>
References: <bug-29752-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:40011 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1BXGDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 01:03:22 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1O63LFM001008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Feb 2011 06:03:22 GMT
In-Reply-To: <bug-29752-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29752





--- Comment #2 from Josh Hunt <joshhunt00@gmail.com>  2011-02-24 06:03:21 ---
Typo in this comment. Should read "... there are NO power failures..."
(In reply to comment #1)
> I wanted to add that there are now power failures, application crashes, etc
> when these inodes are unattached. Also we are seeing this on multiple (read
> 10+) machines.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
