From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60676] Stat system call gives permission denied to root for
 links under a sticky bit
Date: Fri, 02 Aug 2013 14:34:36 +0000
Message-ID: <bug-60676-13602-h9fkyanrD2@https.bugzilla.kernel.org/>
References: <bug-60676-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47256 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3HBOek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Aug 2013 10:34:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C32B720450
	for <linux-ext4@vger.kernel.org>; Fri,  2 Aug 2013 14:34:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9A15020441
	for <linux-ext4@vger.kernel.org>; Fri,  2 Aug 2013 14:34:36 +0000 (UTC)
In-Reply-To: <bug-60676-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60676

James Kolb <jck@videk.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #4 from James Kolb <jck@videk.com> ---
That makes sense. Thanks! It looks like the man pages just need to be updated.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
