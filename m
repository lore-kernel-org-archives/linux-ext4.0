From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Fri, 5 Jun 2009 00:51:54 GMT
Message-ID: <200906050051.n550psZ3029509@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38658 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZFEAvw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 20:51:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n550pscK029510
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jun 2009 00:51:54 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201





--- Comment #8 from Franco Broi <franco@fugro-fsi.com.au>  2009-06-05 00:51:52 ---
I haven't been able to recreate the problem using 2.6.30-rc8 but the test
conditions aren't identical to before. Would it make a difference that only a
single filesystem is being written to and not 4 simultaneously as in the
original tests?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
