Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38956 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387668AbeKVJfg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 04:35:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7D0B42C4A8
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 22:59:08 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 22:59:07 +0000
Message-ID: <bug-201685-13602-lpMm89gDF3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #23 from Theodore Tso (tytso@mit.edu) ---
Jimmy, I don't blame you.   Unfortunately, I don't have a clean repro of the
problem because when I tried building a 4.20-rc2 kernel with
CONFIG_SCSI_MQ_DEFAULT=y, and tried running gce-xfstests, no problems were
detected.  And I'm too chicken to try running a kernel version which does have
the problem reported with CONFIG_SCSI_MQ_DEFAULT=y on my primary development
laptop.   :-)

I will say that if you are seeing problems on a particular file system (e.g.
/), by the time the kernel is reporting inconsistencies, the damage is already
done. Yes, you might want to try doing a backup before you reboot, in case the
system doesn't come back, but realistically speaking, the longer you keep
running, the problems are more likely to compound.

So from a personally very selfish perspective, I'm hoping someone who has
already suffered corruption problems is willing to try either 4.19.3, or
disabling CONFIG_SCSI_MQ_DEFAULT, or both, and report that they are no longer
seeing problems, than my putting my own personal data at risk....

Maybe over T-day weekend, I'll try doing a full backup, and then try using
4.19.3 on my personal laptop --- but a "it works fine for me" report won't
necessarily mean anything, since to date I'm not able to reproduce the problem
on one of my systems.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
