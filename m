From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 19:20:35 GMT
Message-ID: <200905241920.n4OJKZRG029532@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40883 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZEXTUd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 15:20:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4OJKZQG029533
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 19:20:35 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #12 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-05-24 19:20:34 ---
Can you try with the patch series found at

http://article.gmane.org/gmane.comp.file-systems.ext4/12962
(Threading is not working for gmane currently so the two patches
you may need are
http://thread.gmane.org/gmane.linux.file-systems/31465
http://thread.gmane.org/gmane.comp.file-systems.ext4/12960
)

I guess mmap and truncate combination can result in we missing pagefault
when we write to second block in the same page. That would mean we may
have to do block allocation in writepage.

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
