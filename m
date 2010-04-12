From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15768] Incorrectly calculated free blocks result in ENOSPC from
 writepage
Date: Mon, 12 Apr 2010 19:14:36 GMT
Message-ID: <201004121914.o3CJEaJr032659@demeter.kernel.org>
References: <bug-15768-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51912 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab0DLTOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 15:14:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3CJEaEu032660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 19:14:36 GMT
In-Reply-To: <bug-15768-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15768





--- Comment #4 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-12 19:14:30 ---
Updated version of the fix posted here.
http://patchwork.ozlabs.org/patch/49989/

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
