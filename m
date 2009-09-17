From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13604] cascade of "mpage_da_map_blocks block allocation failed"
 errors
Date: Thu, 17 Sep 2009 15:51:14 GMT
Message-ID: <200909171551.n8HFpEHX020176@demeter.kernel.org>
References: <bug-13604-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35433 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbZIQPvL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 11:51:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8HFpEdR020177
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 15:51:14 GMT
In-Reply-To: <bug-13604-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13604


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2009-09-17 15:51:13 ---
re: comment #3 It's the same end result, delalloc data with nowhere to go.

But the first 2 filers were hitting errno -28 == ENOSPC, where ext4
oversubscribed delayed allocation.  I think this is still a corner case bug
upstream, but better than it was.

comment #3 is an older ext4 codebase hitting quota problems (-122 == EDQUOT)
which should be fixed upstream now.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
