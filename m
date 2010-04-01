From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15666] e2fsck -fD on ext4 breaks
Date: Thu, 1 Apr 2010 10:39:26 GMT
Message-ID: <201004011039.o31AdQQl030994@demeter.kernel.org>
References: <bug-15666-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42297 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0DAKj0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 06:39:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o31AdQOT030998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 10:39:26 GMT
In-Reply-To: <bug-15666-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15666





--- Comment #1 from Nelson Chan <khcha.n.el@gmail.com>  2010-04-01 10:39:23 ---
just found that same issue appears on ext3 too.
Thanks

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
