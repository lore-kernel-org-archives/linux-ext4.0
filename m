From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Fri, 22 Oct 2010 21:55:21 GMT
Message-ID: <201010222155.o9MLtLNe020561@demeter1.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55680 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0JVVzY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 17:55:24 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9MLtL9D020562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 21:55:21 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902





--- Comment #7 from Martin Moerch <martinmoerch@gmail.com>  2010-10-22 21:55:17 ---
Created an attachment (id=34452)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=34452)
dumpe2fs -h from LVMcrypto device

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
