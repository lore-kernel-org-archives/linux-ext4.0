Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50238 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731667AbeKVCrJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 21:47:09 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 69C9D2C147
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 16:12:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 16:12:04 +0000
Message-ID: <bug-201685-13602-sVsj4qJ7yC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #11 from Theodore Tso (tytso@mit.edu) ---
Thanks Jimmy for your report.  Can you specify what sort of LVM devices are you
using?   Is it just a standard LVM volume (e.g., no LVM raid, no LVM snapshops,
no dm-thin provisioning)?

The reason why I ask is because I've run gce-xfstests on 4.19, 4.19.1, and
4.19.2, and it uses LVM (nothing fancy just standard LVM volumes, although
xfstests will layer some dm-error and dm-thin on top of the LVM volumes for
specific xfstests) on top of virtio-scsi on top of Google Compute Engine's
Persistent Disks, and I'm not noticing any problems.

I just noticed that my .config file for my GCE testing has
CONFIG_SCSI_MQ_DEFAULT set to "no", which means I'm not using the new block-mq
data path.   So perhaps this is a MQ specific bug?   (Checking... hmm, my
laptop running 4.19.0 plus the ext4 commits landing in 4.20-rc2+ is *also*
using CONFIG_SCSI_MQ_DEFAULT=n.)   And Kconfig recommends that SCSI_MQ_DEFAULT
be defaulted to y.

This is why having people include their Kernel configs, and what devices they
use is so important.   The vast amount of time, given the constant testing
which we do in the ext4 layer, more often than not the problem is somewhere
*else* in the storage stack.   There have been bugs which have escaped notice
by our tests, yes.  But it's rare, and it's almost never the case when a large
number of users are reporting the same problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
