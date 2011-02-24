From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29752] Possible i_nlink race in ext2_rename
Date: Thu, 24 Feb 2011 06:02:50 GMT
Message-ID: <201102240602.p1O62oQZ023806@demeter1.kernel.org>
References: <bug-29752-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:57515 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1BXGCu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 01:02:50 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1O62oZu023807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Feb 2011 06:02:50 GMT
In-Reply-To: <bug-29752-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29752





--- Comment #1 from Josh Hunt <joshhunt00@gmail.com>  2011-02-24 06:02:48 ---
I wanted to add that there are now power failures, application crashes, etc
when these inodes are unattached. Also we are seeing this on multiple (read
10+) machines.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
