From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Wed, 05 Jul 2017 13:12:55 +0000
Message-ID: <bug-196223-13602-7KgADbRluH@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36280 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752546AbdGENNA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 09:13:00 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8F89728536
        for <linux-ext4@vger.kernel.org>; Wed,  5 Jul 2017 13:12:59 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #8 from Marta Löfstedt (marta.lofstedt@intel.com) ---
FYI, for the BDW NUCi5 I am using to manually reproduce this issue, I can't not
reproduce with next-20170704 nor next-20170705. However, we are still seeing
the issue on a lot of machines in our i915 CI lab on the same tags built with
the same configuration. 
Unfortunately, this weakens my statement about next-20170627 being a good tag,
since this tag has not been run in our lab and now the results for my local
machine has started to diverge from the lab results.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
