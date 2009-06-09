From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Tue, 9 Jun 2009 05:10:32 GMT
Message-ID: <200906090510.n595AWnV030297@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43325 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZFIFKa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jun 2009 01:10:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n595AWGo030298
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 05:10:32 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201





--- Comment #10 from Franco Broi <franco@fugro-fsi.com.au>  2009-06-09 05:10:31 ---
(In reply to comment #9)
> If this is the same problem as the one which we fixed with identical symptoms,
> what matters is multiple processes/threads writing to the same file at the same
> time.

Then it doesn't sound like it's the same bug. My tests are very simple, they
just keep writing 8GB files until the disk fills up, there is no concurrent
access to files or even the filesystem, and the machines are completely
standalone.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
