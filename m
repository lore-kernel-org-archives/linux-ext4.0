From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] serious performance regression in "umount" on ext4 over
 LVM
Date: Tue, 4 May 2010 21:12:52 GMT
Message-ID: <201005042112.o44LCqmJ017839@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33860 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754Ab0EDVMx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 17:12:53 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o44LCqep017840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 21:12:52 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #6 from Kees Cook <kees@outflux.net>  2010-05-04 21:12:51 ---
Hm, it seemed to be progressively worse since 2.6.28 (when it was okay).  It
was not good in 2.6.31, and bad in 2.6.32.  So I don't have data for 2.6.29 or
.30.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
