From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Sat, 8 Aug 2009 17:10:07 GMT
Message-ID: <200908081710.n78HA7BG004459@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48186 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZHHRKJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Aug 2009 13:10:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n78HA8xA004460
	for <linux-ext4@vger.kernel.org>; Sat, 8 Aug 2009 17:10:08 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #4 from Michael B. Trausch <mike@trausch.us>  2009-08-08 17:10:05 ---
I can't reproduce the problem in any of my installed 2.6.30.y stable kernels...
The output from dmesg would likely be needed here.

As for my inability to boot my 2.6.30 system, it seems there's a bug in Karmic
(or grub2) that fails to generate the proper boot entries for my old system. 
Oops.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
