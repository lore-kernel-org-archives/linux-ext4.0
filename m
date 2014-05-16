From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 03:36:05 +0000
Message-ID: <bug-76261-13602-6mpVMT3Ibg@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54769 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaEPDgH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 23:36:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BA05A2039C
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:36:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 606982038F
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:36:05 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
You use the equivalent of umount -a (which is what Linux distributions that
don't have a pathological fear of GPL'ed code use --- i.e., everyone else
except Android).   So this is just the matter of writing code which attempts to
unmount all of the file systems, one by one.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
