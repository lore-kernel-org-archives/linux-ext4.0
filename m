Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35960 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbeKZKxO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 05:53:14 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9B674299C8
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 00:00:54 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 26 Nov 2018 00:00:54 +0000
Message-ID: <bug-201685-13602-vycvkbt9h3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #46 from Theodore Tso (tytso@mit.edu) ---
So Henrique, the only difference between the 4.19.3 kernel that worked and the
one where you didn't see corruption was CONFIG_SCSI_MQ_DEFAULT?   Can you diff
the two configs to be sure?

What can you tell us about the SSD?  Is it a SATA-attached SSD, or
NVMe-attached?

What I can report is my personal development laptop is running 4.19.0 (plus the
ext4 patches that landed in 4.20-rc1) with CONFIG_SCSI_MQ_DEFAULT=n?  (Although
as others have pointed out, that shouldn't matter since my SSD is
NVMe-attached, and so it doesn't go through the SCSI stack.)   My laptop runs
Debian unstable, and uses an encrypted LUKS partition on top of which I use
LVM.   I do use regular suspend-to-ram (not suspend-to-idle, since that burns
way too much power; there's a kernel BZ open on that issue) since it is a
laptop.

I have also run xfstest runs using 4.19.0, 4.19.1, 4.19.2, and 4.20-rc2 with
CONFIG_SCSI_MQ_DEFAULT=n; it's using the gce-xfstests[1] test appliance which
means I'm using virtio-SCSI on top of LVM, and it runs a large number of
regression tests, many with heavy read/write loads, but none of the file
systems is mounted for more than 5-6 minutes before we unmount and then run
fsck on it.  We do *not* do any suspend/resumes, although we do test the file
system side of suspend/resume using the freeze and thaw ioctls.  There were no
unusual problems noticed.  

[1] https://thunk.org/gce-xfstests

I have also run gce-xfstests on 4.20-rc2 with CONFIG_SCSI_MQ_DEFAULT=y, with
the same configuration as above --- vrtio-scsi with LVM on top.   There was
nothing unusual that was detected there.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
