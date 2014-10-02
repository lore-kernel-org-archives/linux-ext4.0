From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85381] ext4 & tmpfs: Splicing to regular files doesn't trigger
 inotify
Date: Thu, 02 Oct 2014 12:05:01 +0000
Message-ID: <bug-85381-13602-9u1PWGgH4T@https.bugzilla.kernel.org/>
References: <bug-85381-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46484 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaJBMFE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Oct 2014 08:05:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E85A32027D
	for <linux-ext4@vger.kernel.org>; Thu,  2 Oct 2014 12:05:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4ECCF20272
	for <linux-ext4@vger.kernel.org>; Thu,  2 Oct 2014 12:05:01 +0000 (UTC)
In-Reply-To: <bug-85381-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=85381

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |jack@suse.cz
         Resolution|---                         |CODE_FIX

--- Comment #1 from Jan Kara <jack@suse.cz> ---
So this isn't a problem with current kernel (I tested 3.17-rc5) anymore. I
believe it got fixed by Al Viro's splice rewrite so 3.16 and newer kernels
should have the problem fixed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
