From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 15 Oct 2009 17:58:03 GMT
Message-ID: <200910151758.n9FHw3GO003228@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35180 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935035AbZJOR6j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 13:58:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9FHw3nP003229
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 17:58:03 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #55 from Theodore Tso <tytso@mit.edu>  2009-10-15 17:58:01 ---
hmm.. that's an interesting suggestion.   Is anyone who is reporting problems
_not_ using Karmic userspace?  

I'm using Ubuntu 9.04.... maybe that's why I can't reproduce it?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
