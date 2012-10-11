From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Thu, 11 Oct 2012 20:54:00 +0000 (UTC)
Message-ID: <20121011205400.2D0AB11FA36@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34689 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab2JKUyH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 16:54:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1769D2049A
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2012 20:54:06 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3E10520498
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2012 20:54:05 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #16 from Elmar Stellnberger <estellnb@elstel.org>  2012-10-11 20:53:59 ---
> the real device is just making up the disk block sizes anyway
Yes, in our case it would make up a block size of 8KB

> alignment according to the identify data is important 
No, only for HDDs not for SSDs; here the alignment needs to fit
the internal or exposed alignment of the SSD in order not to
ruin it by a 2x or 4x-ing of all read-write cycles

> this isn't particularly likely to change
Yes, folks of any chat channel are not aware of these issues.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
