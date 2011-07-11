From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Mon, 11 Jul 2011 10:26:49 GMT
Message-ID: <201107111026.p6BAQnZq013698@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60770 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1GKK0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jul 2011 06:26:49 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6BAQnOZ013699
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jul 2011 10:26:49 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072





--- Comment #7 from Theodore Tso <tytso@mit.edu>  2011-07-11 10:26:45 ---
Lars, thanks for trying out the tracepoint.  

Marcin, would it be convenient / posible for you to give this patch a try?  
And would you be willing to work with some of the other folks at Arch linux and
Ubuntu?   More importantly, once you find the guilty parties that are
constantly syslogging or constantly modifying files (log files or database
files or whatever), can you help with filing bugs upstream with the
applications in question?

The reason people with many different applications are seeing this problem is
because many application writers are careless with their programming, and so we
need as many people as possible investigating problems and complaining to the
application programmers.

Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
