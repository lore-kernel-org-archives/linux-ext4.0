From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Mon, 29 Mar 2010 08:17:18 GMT
Message-ID: <201003290817.o2T8HIKV010825@demeter.kernel.org>
References: <bug-15579-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56273 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0C2IRU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Mar 2010 04:17:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2T8HITg010826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 08:17:18 GMT
In-Reply-To: <bug-15579-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15579





--- Comment #8 from Andreas Beckmann <kernel-bugs@abeckmann.de>  2010-03-29 08:16:54 ---
(In reply to comment #7)
> If the number of available unmapped blocks has an impact, that seems most
> likely to be a SSD firmware bug to me.
> 
> ie. If the linux kernel is sending control messages in the wrong order, then it
> should cause corruption regardless of the number of unmapped blocks.

That's correct except that you may get a timing issue (e.g. writing to free
unmapped blocks is/could be/should be a bit faster than clearing the blocks
first) which could turn this into race condition debugging ...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
