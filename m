From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Tue, 23 Mar 2010 14:29:42 GMT
Message-ID: <201003231429.o2NETgBr021307@demeter.kernel.org>
References: <bug-15579-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32808 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab0CWO3n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Mar 2010 10:29:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2NETgM0021308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Mar 2010 14:29:42 GMT
In-Reply-To: <bug-15579-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15579





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2010-03-23 14:29:35 ---
(In reply to comment #5)

> What do you do on the remaining space of the SSD? Try putting a file system
> there and fill it with something so that the SSD is 99% filled so it can't that
> easily remap the blocks you are writing to.

Hm, I suppose that could be, and it makes it a little harder to write a generic
testcase....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
