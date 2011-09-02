From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Fri, 2 Sep 2011 13:09:22 GMT
Message-ID: <201109021309.p82D9M8w021175@demeter2.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39956 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1IBNJX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Sep 2011 09:09:23 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p82D9Man021176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Sep 2011 13:09:23 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682





--- Comment #11 from Sedat Dilek <sedat.dilek@gmail.com>  2011-09-02 13:09:21 ---
Official patch from Ted:
"ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining" [1]
See also "[GIT PULL] ext4 fixes for 3.1-rc5" [2].
( Patch is not in mainline yet. )

[1]
https://github.com/tytso/ext4/commit/8c0bec2151a47906bf779c6715a10ce04453ab77
[2] http://lkml.org/lkml/2011/8/31/262

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
