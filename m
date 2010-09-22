From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Wed, 22 Sep 2010 18:01:50 GMT
Message-ID: <201009221801.o8MI1o41024440@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:54058 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0IVSBv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Sep 2010 14:01:51 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8MI1osm024441
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 22 Sep 2010 18:01:50 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361





--- Comment #10 from Christian Casteyde <casteyde.christian@free.fr>  2010-09-22 18:01:49 ---
Created an attachment (id=31032)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=31032)
.config file

I append the .config file, just to tell what are the kernel debug options I
use.
I'm running in 64bit and build from vanilla source, with gcc 4.4.4.

I don't think this is hardware related, since I get the same on my laptop. More
some racy problems in udev/ldconfig/fc-cache

I'm still thinking it's a vfs problem or kmemcheck itself bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
