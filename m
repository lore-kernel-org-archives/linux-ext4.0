From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27912] Set 'err' in ext4_init_fs() if kset_create_and_add()
 fails
Date: Tue, 1 Feb 2011 10:27:44 GMT
Message-ID: <201102011027.p11ARiGt001677@demeter1.kernel.org>
References: <bug-27912-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:53821 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1BAK1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Feb 2011 05:27:45 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p11ARirp001678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 1 Feb 2011 10:27:44 GMT
In-Reply-To: <bug-27912-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27912





--- Comment #2 from Eugene A. Shatokhin <dame_eugene@mail.ru>  2011-02-01 10:27:36 ---
Ah, that is why there were 3 references to ext4_kset right before
kset_unregister() rather than just one! 

Yes I will try the patch, thank you. 

However, it does not seem to fix the original problem I reported: 'err' remains
0 in ext4_init_fs() if kset_create_and_add() fails for some reason. I suppose
it is quite easy to fix though.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
