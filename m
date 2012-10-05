From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Fri,  5 Oct 2012 17:26:57 +0000 (UTC)
Message-ID: <20121005172657.2A75811FC3E@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37901 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2JER1A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 13:27:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BCC362050F
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 17:26:59 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2CA7220533
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 17:26:57 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #8 from Elmar Stellnberger <estellnb@elstel.org>  2012-10-05 17:26:56 ---
8K is to be understood instead of the usual 4K as page size (smallest read- and
writeable entity). Eric: I doubt that anyone would file a bug report on it as
the only effect of using a wrong fs block size will be degraded performance and
a shortened lifetime of the SSD (nobody would in deed find out about it who
hasn`t tried it with 8KB block size or heard about disks with page size != 4K).
Feel free to care about it whenever you want as we do not have any users
requiring it yet (to me for myself this isn`t any issue since I don`t plan to
use the besaid disk at the time).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
