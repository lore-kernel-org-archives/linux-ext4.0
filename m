From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Wed, 2 Jun 2010 12:02:21 GMT
Message-ID: <201006021202.o52C2LcF018278@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46160 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0FBMCW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 08:02:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o52C2Mta018279
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jun 2010 12:02:22 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #5 from lkolbe@techfak.uni-bielefeld.de  2010-06-02 12:02:18 ---
e2fsck segfaulted after about an hour on the first volume and had gazillions of
questions for the second.

I don't know about barriers, mount says:
/dev/mapper/data-badp2 on /var/bacula/diskpool/fs2 type ext4 (rw,nosuid,nodev)

Wether the Adaptec 52445 supports barriers - I really don't know?
The Serial console is now finally working, so if this happens again we'll get a
full stacktrace. It will most likely take a few days of backup runs to trigger,
though. Thanks for looking into this!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
