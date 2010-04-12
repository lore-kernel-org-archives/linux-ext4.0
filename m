From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15768] Incorrectly calculated free blocks result in ENOSPC from
 writepage
Date: Mon, 12 Apr 2010 18:30:40 GMT
Message-ID: <201004121830.o3CIUerM022486@demeter.kernel.org>
References: <bug-15768-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47369 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0DLSan (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 14:30:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3CIUemO022488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 18:30:40 GMT
In-Reply-To: <bug-15768-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15768





--- Comment #3 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-12 18:30:35 ---
(In reply to comment #2)
> proposed patch http://patchwork.ozlabs.org/patch/49963/
Opps, the patch attached is wrong in case of no_journal mode.
Will send new version soon.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
