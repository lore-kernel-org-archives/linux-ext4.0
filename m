From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling barriers  -- and then hang
Date: Wed,  4 Mar 2009 09:15:03 -0800 (PST)
Message-ID: <20090304171503.983E611D108@picon.linux-foundation.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbZCDRPe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 12:15:34 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n24HF34d027465
	for <linux-ext4@vger.kernel.org>; Wed, 4 Mar 2009 09:15:05 -0800
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815





------- Comment #4 from sandeen@redhat.com  2009-03-04 09:15 -------
(In reply to comment #3)
> I'm getting the JBD message not only on initial mount. Is that still expected?

You should get it on each mount.  When else do you see it?

> I'll try to get some info from sysrq if it happens again.
> 
> Is there any mount option I can use to disable delayed allocation or something
> to try to work around the problem?

You can mount with -o nodelalloc, though there is no reason to think that this
is related to the problem at this point ... it may be more productive to test a
newer kernel.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
