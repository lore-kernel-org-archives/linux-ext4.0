From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Mon, 10 Jul 2017 05:10:42 +0000
Message-ID: <bug-196223-13602-gAlnOLhrTe@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53488 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750924AbdGJFKn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Jul 2017 01:10:43 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1C1122842B
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jul 2017 05:10:43 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #16 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
For the future IGT runs: basic set ("BAT") is run with -t basic. Our short
testset can be run with -T tests/intel-ci/fast-feedback.testlist.

Most of the igt-all 60k tests are gem_concurrent_blit ones (50k+). Everything
else should be in better shape. We're working to get all tests runnable in
reasonable time and successfully, at the moment expected time taken for igt all
is 3 weeks on one host.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
