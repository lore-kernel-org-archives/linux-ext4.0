From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sat, 23 May 2009 12:07:40 GMT
Message-ID: <200905231207.n4NC7elF022596@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36089 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZEWMHi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 May 2009 08:07:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4NC7eL4022597
	for <linux-ext4@vger.kernel.org>; Sat, 23 May 2009 12:07:40 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #1 from Chris Komner <ckom26@gmail.com>  2009-05-23 12:07:40 ---
Created an attachment (id=21506)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=21506)
Kernel logs of the bug, had to pull the plug to get the second one since the
box wouldn't reboot normally.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
