From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14422] EXT4 is corrupted after clean shutdown
Date: Thu, 22 Oct 2009 14:54:09 GMT
Message-ID: <200910221454.n9MEs9M8031486@demeter.kernel.org>
References: <bug-14422-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50262 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZJVOyF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 10:54:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9MEs9aB031487
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2009 14:54:09 GMT
In-Reply-To: <bug-14422-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14422





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2009-10-22 14:54:08 ---
We can try to reproduce, but if there is any possibility of attaching actual
e2fsck output, that would be most helpful.

thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
