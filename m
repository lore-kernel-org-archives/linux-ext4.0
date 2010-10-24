From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18302] [BUG] bad performance and system stalls when using
 dm-crypt
Date: Sun, 24 Oct 2010 15:48:57 GMT
Message-ID: <201010241548.o9OFmvRC005541@demeter2.kernel.org>
References: <bug-18302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:52259 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab0JXPs6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Oct 2010 11:48:58 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9OFmwKO005542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 24 Oct 2010 15:48:58 GMT
In-Reply-To: <bug-18302-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=18302





--- Comment #1 from david b <db.pub.mail@gmail.com>  2010-10-24 15:48:56 ---
...
For example:
doing something stupid like this 

dd if=/dev/zero of=TEMP count=15553600 &
dd if=/dev/zero of=TEMP2 count=15553600 &
ls -lahR / &
will --> end up with the following output :/

fsync time: 25.8393
pread time: 0.0010
fsync time: 20.6251
pread time: 0.0007
fsync time: 31.0960
pread time: 5.3767
fsync time: 28.0393
pread time: 16.1137
fsync time: 19.2237
pread time: 12.9312
fsync time: 25.0550
pread time: 6.7220
fsync time: 9.8830
pread time: 0.0009

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
