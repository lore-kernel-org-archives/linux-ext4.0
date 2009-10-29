From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 22:23:42 GMT
Message-ID: <200910292223.n9TMNgqY019708@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38179 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbZJ2WXh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 18:23:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TMNg8j019709
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 22:23:42 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #150 from Eric Sandeen <sandeen@redhat.com>  2009-10-29 22:23:41 ---
Created an attachment (id=23592)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23592)
console log w/ aneesh's patch

Well, now that I look again, w/ Aneesh's patch it didn't show up the
multiply-claimed blocks this time, but did still have pretty massive
corruption.  Probably needs a few more test runs to make sure that's not a
fluke.

Attached is a console log of the fs errors runtime, followed by the boot-time
fsck.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
