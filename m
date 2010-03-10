From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Wed, 10 Mar 2010 06:56:40 GMT
Message-ID: <201003100656.o2A6uebw017479@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54319 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab0CJG4l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 01:56:41 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2A6ueCB017480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 06:56:40 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #20 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-03-10 06:56:33 ---
Created an attachment (id=25447)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25447)
additional data from kernel 2.6.32.9-67.fc12.x86_64

Again, I have had very limited time, but I ran an 
rsync after update to kernel 2.6.32.9-67.fc12.x86_64.

The time for sync to complete was about as before,
(about 10 minutes) and timeouts occurred as shown in the
attached log entries.

I assume that the patches are not included in this
kernel, but I just thought that I should report this test.

Michael

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
