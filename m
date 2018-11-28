Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45216 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727726AbeK2CLn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 21:11:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 118482D661
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 15:09:45 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 15:09:45 +0000
Message-ID: <bug-201685-13602-Brjxiy4GGa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #63 from Michel Dänzer (michel@daenzer.net) ---
(In reply to Jason Gambrel from comment #3)
> No Raid. 500gb SSD. 16gb ram with a 4gb swap file (not a swap partition).

FWIW, I was running into ext4 metadata corruption every few days with 4.19
using swap files (on the ext4 / on LVM on LUKS). On a hunch, switched to a swap
partition on LVM on LUKS two weeks ago, and haven't run into it since. Swap
files were working fine with pre-4.19 kernels. In case it matters, I run fstrim
in a weekly cronjob, with discard enabled in /etc/lvm/lvm.conf and
/etc/crypttab.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
