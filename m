From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Fri,  6 Mar 2009 06:18:47 -0800 (PST)
Message-ID: <20090306141847.D80A6108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbZCFOSv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 09:18:51 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n26EImIi026183
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 06:18:49 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #10 from apw@canonical.com  2009-03-06 06:18 -------
e2fsprogs 1.41.4ubuntu1 is available in Jaunty so you could pick those tools up
from the URL below:

   
http://archive.ubuntu.com/ubuntu/pool/main/e/e2fsprogs/e2fsprogs_1.41.4-1ubuntu1_amd64.deb
   
http://archive.ubuntu.com/ubuntu/pool/main/e/e2fsprogs/e2fsprogs_1.41.4-1ubuntu1_i386.deb


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
