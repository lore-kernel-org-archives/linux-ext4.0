From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Fri, 13 Feb 2009 18:07:28 -0800 (PST)
Message-ID: <20090214020728.8361711D10A@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbZBNCHb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 21:07:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1E27SWi012858
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 18:07:29 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #10 from tytso@mit.edu  2009-02-13 18:07 -------
> Patch from Aneesh, un-whitespace-mangled.
> 
> Ted, can you push this out?  Works great.  :) We might want to ask
> the other reporter of something similar (next-20090206: deadlock on
> ext4) to test it too.  I'll ping him.

Do we completely understand the root cause, in terms of which commit
broken the mm/page-writeback.c code we were depending on?  And if so,
what of the code in mm/page-writeback.c?  Does anyone else use it?
Can anyone sanely use it?

And am I right in assuming that this only applies to 2.6.29-rcX
kernels, and is not needed for 2.6.28 or earlier kernels?

I hadn't yet pushed it out because I needed time to understand all of
these issues, hence these questions....

                                                - Ted


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
