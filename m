From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14734] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000808
Date: Wed, 9 Dec 2009 12:27:41 GMT
Message-ID: <200912091227.nB9CRfqe015699@demeter.kernel.org>
References: <bug-14734-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50775 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbZLIM1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Dec 2009 07:27:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nB9CRfdx015700
	for <linux-ext4@vger.kernel.org>; Wed, 9 Dec 2009 12:27:41 GMT
In-Reply-To: <bug-14734-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14734


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #2 from Jan Kara <jack@suse.cz>  2009-12-09 12:27:39 ---
I believe this is a faulty memory:
Looking at the disassembly we most probably oopsed while doing
page_cache_get_speculative(page) where page was 0000000000000800. So it's a
single bit flip from NULL in which case we'd just go on with another page.
Could you try running memtest for some time?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
