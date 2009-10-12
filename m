From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 12 Oct 2009 07:57:59 GMT
Message-ID: <200910120757.n9C7vxL6026050@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59962 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZJLH6f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 03:58:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9C7vxBO026053
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 07:57:59 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #22 from Holger Freyther <zecke@selfish.org>  2009-10-12 07:57:58 ---
Created an attachment (id=23358)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23358)
fsck.log with blocks assigned to multiple inodes.

So the fs assigned recent blocks both to my WebKit build and git pull --rebase
in the kernel tree.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
