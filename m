From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15792] ext4_inode_info->i_flags modification is racy
Date: Mon, 19 Apr 2010 14:38:12 GMT
Message-ID: <201004191438.o3JEcCAO019461@demeter.kernel.org>
References: <bug-15792-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58268 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0DSOiN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 10:38:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3JEcC2A019462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 14:38:12 GMT
In-Reply-To: <bug-15792-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15792





--- Comment #6 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-19 14:38:10 ---
Proposed patches
http://patchwork.ozlabs.org/patch/50468/
http://patchwork.ozlabs.org/patch/50469/

My hosts survived reasonable amount of time with these patches.
If everybody agree with the first patch, I'll prepare similar one for ext3.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
