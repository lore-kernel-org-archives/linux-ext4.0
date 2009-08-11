From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Tue, 11 Aug 2009 22:35:26 GMT
Message-ID: <200908112235.n7BMZQ11010083@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38463 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZHKWfZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 18:35:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7BMZQQW010084
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 22:35:26 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #27 from Rus <harbour@sfinx.od.ua>  2009-08-11 22:35:25 ---
1. The test from non-root user passes.
2. Testing as root on IMA enabled kernel passes only files up to some size,
seems like 1GB is limit. All files that are bigger - hangs forever. The below
1GB file test on IMA kernel - it completed in 4 seconds. But files more than
1GB (I've tested 2GB and 3GB) hangs forever - I was waiting for 10 minuites -
no success. 

[Hors]:rus:~ # time -p md5sum 1GB 
5430f5bdcde8f7c3c222df24eed64741  1GB
real 4.39
user 2.84
sys 1.45

It is very strange that such size limit is present and it is not configurable.
Or this is IMA bug.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
