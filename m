From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14472] EXT4 corruption
Date: Thu, 29 Oct 2009 21:44:46 GMT
Message-ID: <200910292144.n9TLikBZ009701@demeter.kernel.org>
References: <bug-14472-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49554 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZJ2Vol (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:44:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TLik3r009702
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 21:44:46 GMT
In-Reply-To: <bug-14472-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14472


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2009-10-29 21:44:45 ---
Lest champagne break out too early, I have still seen corruption with this
patch in place, while running my testcase (mentioned in bug #14354)

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
