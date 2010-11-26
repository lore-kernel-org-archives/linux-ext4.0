From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Fri, 26 Nov 2010 14:40:32 GMT
Message-ID: <201011261440.oAQEeWBK014058@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59782 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0KZOkd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Nov 2010 09:40:33 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAQEeX5w014059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Nov 2010 14:40:33 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772





--- Comment #6 from Theodore Tso <tytso@mit.edu>  2010-11-26 14:40:28 ---
Ooops, sorry, I needed the block #1 of the file system, which means I need the
first two 4k blocks....   so could you send me:

dd if=/dev/dsk/by-label/MyBook of=/tmp/sb.img bs=4k count=2

... and send attach the revised sb.img file.

Many thanks!!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
