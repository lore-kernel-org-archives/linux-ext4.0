From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 26 Oct 2009 22:40:42 GMT
Message-ID: <200910262240.n9QMegX2008177@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46109 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbZJZWkh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Oct 2009 18:40:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9QMegFo008178
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2009 22:40:42 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #121 from Eric Sandeen <sandeen@redhat.com>  2009-10-26 22:40:40 ---
(In reply to comment #89)
> Created an attachment (id=23458)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23458) [details]
> skip the non-journal branch if readonly

I'm skeptical of reports that this patch fixed things as well; from code
inspection and instrumented testing, I don't see how we get here w/ s_journal
NULL on a journalling filesystem mount, even during recovery...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
