From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Fri, 29 Oct 2010 16:23:41 GMT
Message-ID: <201010291623.o9TGNfZ7018396@demeter1.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53519 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab0J2QXm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Oct 2010 12:23:42 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9TGNfLC018397
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 16:23:41 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902


Justin Maggard <jmaggard10@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jmaggard10@gmail.com




--- Comment #9 from Justin Maggard <jmaggard10@gmail.com>  2010-10-29 16:23:36 ---
I just ran into something similar a few days ago.  It was a 4TB filesystem with
about 50,000 files in a mixed data set.  I ran a test script that unmounted,
remounted, and then started writing 64MB files in a loop using dd.  With
delalloc on, the third 64MB write after umount/mount always took about 150
seconds.  With delalloc off, the first write always took ~150 seconds.  Writes
after that were a fraction of a seconds.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
