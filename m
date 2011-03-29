From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30872] Calling kfree() for uninitialized pointer in
 ext4_mb_init_backend()
Date: Tue, 29 Mar 2011 00:08:08 GMT
Message-ID: <201103290008.p2T088ci032627@demeter1.kernel.org>
References: <bug-30872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48095 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1C2AIJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 20:08:09 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2T088NV032628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 00:08:08 GMT
In-Reply-To: <bug-30872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=30872


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #4 from Florian Mickler <florian@mickler.org>  2011-03-29 00:08:04 ---
A patch referencing this bug report has been merged in v2.6.38-8876-g036a982:

commit 4596fe07679ff0fae904515691ea747467614871
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Mar 21 21:25:13 2011 -0400

    ext4: don't kfree uninitialized s_group_info members

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
