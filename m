From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Tue, 11 Jul 2017 08:40:50 +0000
Message-ID: <bug-196223-13602-Fv3dZMX4Gf@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47104 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755399AbdGKIkw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Jul 2017 04:40:52 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B33A827F7F
        for <linux-ext4@vger.kernel.org>; Tue, 11 Jul 2017 08:40:51 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #21 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
There is probably two issues here:
- disabled NVMe controller on kbl-7700k with NVMe

This issue is easily reproduced with gem_exec_suspend@basic-s3, just loop it.
Has been triggered in linus-v4.12, linux-next and DRM-Tip builds, just fastest
to hit on linux-next.

- 60sec timeout and panic from watchdog on most of the other hosts

This might be controller / disk issue too, but I can't read the log well enough
to tell if that's the case.

This latter issue is probably what Marta was tracking, and it's much harder to
reproduce manually. IGT fast-feedback runs seem to hit it very regularly, for
some reason. There's nothing magical in what CI is doing: Open SSH connection
which is kept up, start Jenkins-CI Java client, this starts IGT run through a
shell script. This all within ~30 seconds of testhost OpenSSH starting up.

Collected traces from todays 20170711 run, very different hosts:

https://intel-gfx-ci.01.org/CI/next-20170711/fi-ivb-3520m/dmesg-149974972_Panic_1.log
fi-ivb-3520m: HP Elitebook 8440p laptop with Intel SSD 520

https://intel-gfx-ci.01.org/CI/next-20170711/fi-ivb-3770/dmesg-149974971_Panic_1.log
fi-ivb-3770: HP Pro 3500 desktop with Intel SSD 530

https://intel-gfx-ci.01.org/CI/next-20170711/fi-hsw-4770r/dmesg-149974972_Panic_1.log
fi-hsw-4770r: Gigabyte "Brixbox" NUC with Samsung SSD 840 EVO

https://intel-gfx-ci.01.org/CI/next-20170711/fi-bxt-j4205/dmesg-149974980_Panic_1.log
fi-bxt-j4205: Asrock J4205-ITX MB with Intel SSD 530

I'll continue to look for a way to reproduce this issue more easily.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
