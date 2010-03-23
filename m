From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Tue, 23 Mar 2010 21:01:10 GMT
Message-ID: <201003232101.o2NL1A0k008597@demeter.kernel.org>
References: <bug-15579-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45642 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0CWVBL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Mar 2010 17:01:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2NL1A9K008598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Mar 2010 21:01:10 GMT
In-Reply-To: <bug-15579-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15579


Greg.Freemyer@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |Greg.Freemyer@gmail.com




--- Comment #7 from Greg.Freemyer@gmail.com  2010-03-23 21:01:04 ---
If the number of available unmapped blocks has an impact, that seems most
likely to be a SSD firmware bug to me.

ie. If the linux kernel is sending control messages in the wrong order, then it
should cause corruption regardless of the number of unmapped blocks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
