Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34288 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725613AbeLBRsi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 12:48:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 85BE02A782
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 17:48:35 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 17:48:34 +0000
Message-ID: <bug-201685-13602-oZDG3bbCRj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #151 from Jimmy.Jazz@gmx.net ---
(In reply to Jens Axboe from comment #149)

> You had the issue with the full block patch applied, the one that includes
> both the synchronize_rcu() and the quiesce? Or just the partial one I
> suggested earlier?

synchronize_rcu() and the quiesce as you asked me.


> Interesting, so it didn't make it to media.

The following tests has be made on an other computer named orca to not be
confused with earlier comments I have posted.

Again, I can confirm it but only with your patches applied. On orca with 4.20
and w/o your patch the bug was able to entirely wipe out orca postgres database
:(

It gives me the opportunity to do a full reinstall of orca from the stick.
Don't get confused with mmp_node_name host name on the new created partitions,
it has an easy explanation. The bootable stick used to create the filesystems
has a different hostname than the final server (i.e. orca)

Please read the attached bug.orca.tar.xz tar file. You can follow the logs
sequence from the file creation time.

I underline, the new corruption on dm-10 after the server has rebooted has
nothing to do with the one announced  earlier in dmesg. Read dmesg-zalman.txt,
dmesg-zalman-2.txt and dumpe2fs-dm-10-after-e2fsk.txt, dmesg-after-e2fsk.txt in
that order. It shows that dm-10 corruption was initiate during the reboot.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
