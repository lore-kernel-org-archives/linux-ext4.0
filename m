From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] serious performance regression in "umount" on ext4 over
 LVM
Date: Tue, 4 May 2010 21:05:25 GMT
Message-ID: <201005042105.o44L5P7K016070@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60009 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab0EDVF1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 17:05:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o44L5QGl016071
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 21:05:26 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2010-05-04 21:05:24 ---
As I mentioned on the RH bz, it seems barrier-related.

I thought most barrier enhancements/changes were before 2.6.31, though.  Was
this really fast for you on .31?  Lots of lvm barrier changes went into .30.

mounting either the host fs, the loopback file, or both with "nobarrier" avoids
all the cache flushes from the barriers, and it's speedy again.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
