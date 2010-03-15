From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15543] Oops in dentry_iput during ext3 remount readonly
Date: Mon, 15 Mar 2010 20:58:15 GMT
Message-ID: <201003152058.o2FKwFXC032518@demeter.kernel.org>
References: <bug-15543-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59635 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936753Ab0COU6Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Mar 2010 16:58:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2FKwFFS032520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Mar 2010 20:58:16 GMT
In-Reply-To: <bug-15543-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15543





--- Comment #1 from Chris Harrington <ironiridis@gmail.com>  2010-03-15 20:58:09 ---
Oh, it might be helpful to add that this is a pure 64-bit machine.

chris@chariot ~ $ uname -a
Linux chariot 2.6.32-gentoo-r5 #2 SMP Mon Feb 15 12:51:56 CST 2010 i686
Intel(R) Core(TM)2 Duo CPU E8200 @ 2.66GHz GenuineIntel GNU/Linux

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
