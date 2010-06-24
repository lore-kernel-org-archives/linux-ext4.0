From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16278] lvm snapshot causes deadlock in 2.6.35
Date: Thu, 24 Jun 2010 15:28:00 GMT
Message-ID: <201006241528.o5OFS0wa016781@demeter.kernel.org>
References: <bug-16278-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38158 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0FXP2C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2010 11:28:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5OFS0gu016782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jun 2010 15:28:00 GMT
In-Reply-To: <bug-16278-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16278





--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2010-06-24 15:27:57 ---
Created an attachment (id=26933)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26933)
Proposed patch

I've sent this patch upstream, I think it should solve the most egregious
problem here, though I think other deadlocks remain (looking as if they are
unrelated to the commit mentioned in the original comment)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
