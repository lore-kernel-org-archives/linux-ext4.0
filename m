From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15543] Oops in dentry_iput during ext3 remount readonly
Date: Tue, 16 Mar 2010 15:20:57 GMT
Message-ID: <201003161520.o2GFKvsa010700@demeter.kernel.org>
References: <bug-15543-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39418 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0CPPU6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Mar 2010 11:20:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2GFKwTA010701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 16 Mar 2010 15:20:58 GMT
In-Reply-To: <bug-15543-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15543





--- Comment #2 from Chris Harrington <ironiridis@gmail.com>  2010-03-16 15:20:54 ---
(In reply to comment #1)
> Oh, it might be helpful to add that this is a pure 64-bit machine.

More bugspam. I meant "this is *not* a pure 64-bit machine" but of course I
can't get my booleans straight.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
