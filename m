From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Thu, 10 Jun 2010 07:38:13 GMT
Message-ID: <201006100738.o5A7cDY5016885@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44245 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0FJHiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jun 2010 03:38:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5A7cDx3016886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jun 2010 07:38:13 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #8 from Alexander Eichner <Alexander.Eichner@sun.com>  2010-06-10 07:38:08 ---
The chance to reproduce this issue seems to be really dependent of the host.
Just tried it on a Notebook with Ubuntu 10.04 and an ext4 root.

# for I in `seq 1 50`; do ./aio_corrupt /mnt/test$I; done

The test failed only 4 times on 50 runs.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
