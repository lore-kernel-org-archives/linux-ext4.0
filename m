From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Tue, 22 Feb 2011 13:43:12 GMT
Message-ID: <201102221343.p1MDhCl5028413@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:46546 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1BVNnM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 08:43:12 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1MDhC8d028414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 13:43:12 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #5 from Lukas Czerner <lczerner@redhat.com>  2011-02-22 13:43:10 ---
Created an attachment (id=48672)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48672)
Fix ordering patch

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
