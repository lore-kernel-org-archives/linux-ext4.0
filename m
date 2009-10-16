From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14422] EXT4 is corrupted after clean shutdown
Date: Fri, 16 Oct 2009 23:44:13 GMT
Message-ID: <200910162344.n9GNiDX9023928@demeter.kernel.org>
References: <bug-14422-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52835 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZJPXoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 19:44:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GNiDma023929
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 23:44:13 GMT
In-Reply-To: <bug-14422-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14422


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2009-10-16 23:44:12 ---
When stating that a filesystem is corrupted, please offer some indication of
why you believe this to be true; kernel messages indicating on-disk problems,
fsck output, or at least the behavior you see which indicates corruption. 
Otherwise there is simply not enough information to begin any investigation.

If those latest used files are corrupted - how are they corrupted?  missing? 
short?  full of junk?  unreadable? or what?

Thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
