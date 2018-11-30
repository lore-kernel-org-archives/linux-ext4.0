Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33120 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726732AbeLAESm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 23:18:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 55E5C30297
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 17:08:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 17:08:44 +0000
Message-ID: <bug-201685-13602-QtKFgkSNEX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #90 from Hao Wei Tee (angelsl@in04.sg) ---
(In reply to Artem S. Tashkinov from comment #87)
> Maybe one day someone will become truly invested in the kernel development
> process and we'll have proper QA/QC/unit testing/regression
> testing/fuzzying

What we have now is not proper? syzkaller bot, Linux Test Project,
kernelci.org, xfstests, and more that I don't know of. Probably more than any
other OS.

I think it's fair to say Linux has by far more configuration options than any
other kernel out there. It's not feasible to test every single possible
combination. Things will slip through the cracks, especially bugs like this one
where clearly there is something wrong, but not everyone is able to reproduce
it at all. Automated tests are going to miss bugs like this.

We're not doing things worse than anyone else. Apple's APFS had major issues.
Microsoft just had a big problem with their Windows 10 1809 rollout.

Anyway, I remember you from another post you made to LKML complaining about
Linux. You really don't like the way Linux is developed. Why do you still use
it?

I digress.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
