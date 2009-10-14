From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 14 Oct 2009 00:48:02 GMT
Message-ID: <200910140048.n9E0m2jn031754@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50479 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZJNAsi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 20:48:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9E0m2xn031755
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 00:48:02 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #42 from Holger Freyther <zecke@selfish.org>  2009-10-14 00:48:01 ---
Created an attachment (id=23400)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23400)
2: fsck on issue detected in attachment 23398

This is the fsck log. Again indepedent files use the same block. In this case
the .o and other files created during the kernel compile. I will try to prepare
my netbook to work on a reproducable testcase.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
