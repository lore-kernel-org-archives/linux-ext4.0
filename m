From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Tue, 26 May 2009 13:16:29 GMT
Message-ID: <200905261316.n4QDGTnI017382@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35425 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZEZNQ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 May 2009 09:16:28 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4QDGTmt017383
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2009 13:16:29 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #15 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-05-26 13:16:29 ---
Will you be able to try these patches. They are on top
of stable patch from the ext4 patch queue found at 

http://repo.or.cz/w/ext4-patch-queue.git

Apply the patches upto stable-boundary-undo.patch

Then apply the below five patches. Apply them in the below order.

page_cache_size.patch
1.patch
2.patch
unmap_or_unwritten
ext4_writepage

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
