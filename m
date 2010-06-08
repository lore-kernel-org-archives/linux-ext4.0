From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Tue, 8 Jun 2010 22:25:04 GMT
Message-ID: <201006082225.o58MP4QI010206@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34484 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab0FHWZF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jun 2010 18:25:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o58MP43s010207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jun 2010 22:25:04 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2010-06-08 22:25:01 ---
Thanks for the report ... interestingly, testing this on RHEL6 (which is just
what I had conveniently booted, 2.6.32 + backports) seems fine:

# ./aio_corrupt testfile
Success!
# pwd
/mnt/testarea/scratch
# mount | grep scratch
/dev/sdb3 on /mnt/testarea/scratch type ext4 (rw)

I can test 2.6.34 as well, but any other interesting pieces of the setup -
block size less than page size perhaps?

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
