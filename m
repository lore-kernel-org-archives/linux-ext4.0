From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling barriers  -- and then hang
Date: Mon,  9 Mar 2009 08:45:14 -0700 (PDT)
Message-ID: <20090309154514.B472110803F@picon.linux-foundation.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbZCIPpS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Mar 2009 11:45:18 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n29FjF0Q002124
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 08:45:16 -0700
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815





------- Comment #7 from sandeen@redhat.com  2009-03-09 08:45 -------
please attach the entire output of the sysrq-w command, so that we can sort out
what's relevant.  Attaching it rather than pasting it in will have the added
advantage of not wrapping the output :)

Your trace snippets don't show any ext4 code in those callchains.  But they may
be waiting on some stuck ext4 process which you didn't include.

(the summary probably should be changed, as this has nothing to do w/
barriers...)

Thanks,
-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
