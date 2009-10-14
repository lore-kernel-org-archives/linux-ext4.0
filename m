From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 14 Oct 2009 00:45:13 GMT
Message-ID: <200910140045.n9E0jDrK030927@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50434 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZJNApu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 20:45:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9E0jDmY030929
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 00:45:13 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #41 from Holger Freyther <zecke@selfish.org>  2009-10-14 00:45:12 ---
Created an attachment (id=23398)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23398)
2: reboot + mounting ro after journal reply

~2.6.32-rc2 crashed (due a bug in the intel driver), I rebooted into 2.6.31 but
shortly after the journal reply and after the fsck that said everything the fs
got mounted readonly.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
