From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] mount doesn't clear usrjquota / grpjqouta options
Date: Thu, 11 Sep 2014 06:00:01 +0000
Message-ID: <bug-84201-13602-DecsqYDzkT@https.bugzilla.kernel.org/>
References: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49787 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaIKGAH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 02:00:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 70C412020F
	for <linux-ext4@vger.kernel.org>; Thu, 11 Sep 2014 06:00:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A311E201FE
	for <linux-ext4@vger.kernel.org>; Thu, 11 Sep 2014 06:00:01 +0000 (UTC)
In-Reply-To: <bug-84201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

--- Comment #2 from Robin <robinedgar@gmail.com> ---
Unfortunately

# mount -o remount,userjquota=,grpjquota= /
mount: / not mounted or bad option

# mount
/dev/disk/by-uuid/2ceaad1e-7ca8-42f9-b657-ce689beba638 on / type ext4
(rw,relatime,errors=remount-ro,user_xattr,barrier=1,data=ordered,jqfmt=vfsv1,usrjquota=aquota.user,grpjquota=aquota.user)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
