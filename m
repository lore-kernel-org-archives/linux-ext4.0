From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] kernel BUG at fs/ext4/inode.c:1852!
Date: Thu, 11 Feb 2010 04:48:10 GMT
Message-ID: <201002110448.o1B4mAoh014607@demeter.kernel.org>
References: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42188 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0BKEsL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Feb 2010 23:48:11 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1B4mAl7014608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 11 Feb 2010 04:48:10 GMT
In-Reply-To: <bug-15231-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231





--- Comment #12 from Theodore Tso <tytso@mit.edu>  2010-02-11 04:47:31 ---
So the "kernel BUG at fs/inode.c:1343!" failure was showing up on both 2.6.32.2
and 2.6.32.7, right?   Do you know when it first started showing up?

The kernel stack trace indicates that it's coming from releasing one the nfs
kernel thread's network sockets, when the TCP connection is broken or something
else goes wrong.   I don't think it's ext4 related at all; it looks like an NFS
server issue.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
