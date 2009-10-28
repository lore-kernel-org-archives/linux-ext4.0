From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14497] system blocked on "sync" command issued.
Date: Wed, 28 Oct 2009 14:40:35 GMT
Message-ID: <200910281440.n9SEeZcV030199@demeter.kernel.org>
References: <bug-14497-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42273 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZJ1Okb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2009 10:40:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9SEeZnn030200
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2009 14:40:35 GMT
In-Reply-To: <bug-14497-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14497


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2009-10-28 14:40:32 ---
If you ever do recreate this, sysrq-w (echo w > /proc/sysrq-trigger) would show
us all the hung tasks.

-eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
