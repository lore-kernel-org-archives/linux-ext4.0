From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 104571] ext4_mb_generate_buddy block bitmap and bg descriptor
 inconsistent
Date: Mon, 28 Sep 2015 08:37:24 +0000
Message-ID: <bug-104571-13602-oQPdtg4oFt@https.bugzilla.kernel.org/>
References: <bug-104571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40558 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbbI1Ih0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 04:37:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B9E662077B
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 08:37:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5EEEB2077E
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 08:37:24 +0000 (UTC)
In-Reply-To: <bug-104571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=104571

--- Comment #2 from Sander Smeenk <linux-ext4@freshdot.net> ---
e2fsck 1.42.9 (4-Feb-2014)
[ .. ]
Pass 5: Checking group summary information
Block bitmap differences:  +(2520387693--2520387694)
Fix? yes

Free blocks count wrong (57970467, counted=36036558).
Fix? yes

Free inodes count wrong (670746452, counted=670746137).
Fix? yes

/dev/vdb: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdb: 342503/671088640 files (5.9% non-contiguous), 2648318002/2684354560
blocks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
