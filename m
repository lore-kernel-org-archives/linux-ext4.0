From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14156] Running fsstress "fsx" on ext4 filesystem gives dirty
 metadata buffer warning message
Date: Wed, 23 Dec 2009 16:45:11 GMT
Message-ID: <200912231645.nBNGjBe7028260@demeter.kernel.org>
References: <bug-14156-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52677 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbZLWQpM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Dec 2009 11:45:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBNGjB7Y028261
	for <linux-ext4@vger.kernel.org>; Wed, 23 Dec 2009 16:45:11 GMT
In-Reply-To: <bug-14156-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14156


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #3 from Jan Kara <jack@suse.cz>  2009-12-23 16:45:10 ---
Guys, are you still able to reproduce the problem with 2.6.32 kernel?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
