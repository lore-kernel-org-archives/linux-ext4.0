From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Mon, 15 Feb 2010 14:28:43 GMT
Message-ID: <201002151428.o1FEShCX005821@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42512 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0BOO2n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Feb 2010 09:28:43 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1FESh8D005822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Feb 2010 14:28:43 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #18 from Jan Kara <jack@suse.cz>  2010-02-15 14:28:38 ---
Created an attachment (id=25050)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25050)
Fix long sync times during heavy writing

Last week, I've noticed a bug in writeback code causing sync to take longer
than necessary. This patch should fix it. Is it possible for you to try it?
Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
