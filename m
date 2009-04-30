From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Thu, 30 Apr 2009 03:00:49 GMT
Message-ID: <200904300300.n3U30nKP004470@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55577 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZD3DAu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 23:00:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3U30n1p004471
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2009 03:00:49 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201





--- Comment #4 from Franco Broi <franco@fugro-fsi.com.au>  2009-04-30 03:00:48 ---
I ran a test overnight using 2.6.30-rc3-git5 and it didn't fail. Not sure if
this is a good or bad thing?

I've deleted the files and started the test again.

By the way, deleting files with ext4 is lightening fast, it only takes about 5
minutes to delete 13TB! Again, not sure if this is a good or bad thing, it
doesn't give you much time to hit ctrl_c...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
