From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 11 Jan 2010 22:55:41 GMT
Message-ID: <201001112255.o0BMtfEI015510@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53082 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0AKWzm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jan 2010 17:55:42 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0BMtfCD015511
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jan 2010 22:55:41 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #19 from carlos.velasco@nimastelecom.com  2010-01-11 22:55:40 ---
Jan,

You usually run glibc checks with -k (some errors are usual and recurring):
make -k check

You can follow CLFS/LFS guideline here using the pre-downloaded version of
eglibc and patches:
http://cross-lfs.org/view/svn/x86_64/final-system/eglibc-64bit.html

Regards,
Carlos Velasco

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
