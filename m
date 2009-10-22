From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 22 Oct 2009 21:58:10 GMT
Message-ID: <200910222158.n9MLwAPn008849@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44457 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZJVV6G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 17:58:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9MLwAZB008850
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2009 21:58:10 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #106 from Eric Sandeen <sandeen@redhat.com>  2009-10-22 21:58:08 ---
Created an attachment (id=23494)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23494)
Alexey's x86_64 config.

well, Alexey's config seems to have done the trick (read: hosed my test box)
for me.  Attached the x86_64 version he sent me.  I got some serious
multiply-caimed block errors after an apparently failed boot of that kernel.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
