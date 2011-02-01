From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27912] Set 'err' in ext4_init_fs() if kset_create_and_add()
 fails
Date: Tue, 1 Feb 2011 21:07:16 GMT
Message-ID: <201102012107.p11L7GKB027159@demeter1.kernel.org>
References: <bug-27912-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:53965 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1BAVHR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Feb 2011 16:07:17 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p11L7GMr027160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 1 Feb 2011 21:07:16 GMT
In-Reply-To: <bug-27912-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27912





--- Comment #3 from Eugene A. Shatokhin <dame_eugene@mail.ru>  2011-02-01 21:07:13 ---
I have just built and tested the patched ext4.ko module. Yes, the problem with
/sys/fs/ext4 is now fixed as it was expected. 

Obviously, the patch does not fix that problem with 'err' that I reported. So
the patch probably needs to be changed a little.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
