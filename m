From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Thu, 14 Jul 2011 17:30:16 GMT
Message-ID: <201107141730.p6EHUG7O023361@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46932 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1GNRaQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jul 2011 13:30:16 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6EHUGJL023362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2011 17:30:16 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072





--- Comment #13 from Eric Sandeen <sandeen@redhat.com>  2011-07-14 17:30:08 ---
Oh, right, it's a heisenbug; with block_dump enabled you constantly generate
log traffic which must be written, which generates log traffic which must be
written, which generates log traffic which must be written, which ... ;)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
