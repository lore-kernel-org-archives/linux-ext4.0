From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Wed, 9 Jun 2010 15:49:09 GMT
Message-ID: <201006091549.o59Fn9JC008639@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38435 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0FIPtK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 11:49:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o59Fn9ca008640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jun 2010 15:49:09 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2010-06-09 15:49:01 ---
Hm.

# for I in `seq 1 50`; do ./aio_corrupt test$I; done

still works for me.  I don't have any patches in RHEL6 that aren't upstream,
but I'll go ahead & recheck on an upstream kernel, I guess.

Thanks,
-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
