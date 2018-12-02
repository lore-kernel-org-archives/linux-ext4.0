Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38700 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725737AbeLBLh0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 06:37:26 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 16C8828820
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 00:23:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 00:23:40 +0000
Message-ID: <bug-201685-13602-AtRG83HQkL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #117 from Jens Axboe (axboe@kernel.dk) ---
(In reply to Artem S. Tashkinov from comment #87)
> Regression testing could be carried out in a VM running on top of a ramdisk
> (e.g. tmpfs) to speed up the process.
> 
> I guess someone with a decent amount of persistence and spare time could do
> that and test each individual commit between 4.18 and 4.19, however that
> doesn't guarantee success since the bug might be hardware related and not
> reproducible in a virtual environment. Or it might require obscene amounts
> of RAM/disk space which would be difficult, if not impossible to reproduce
> in a VM.
> 
> I for one decided to stay on 4.18.x and not upgrade to any more recent
> kernels until the regression is identified and dealt with.
> 
> Maybe one day someone will become truly invested in the kernel development
> process and we'll have proper QA/QC/unit testing/regression
> testing/fuzzying, so that individuals won't have to sacrifice their data and
> time because kernel developers are mostly busy with adding new features and
> usually not really concerned with performance, security and stability of
> their code unless they are pointed at such issues.

You obviously have no idea wtf you are talking about, I suggest you go
investigate just how much testing is done, continuously, on things like file
system and storage. I take personal offense in in claims that developers "are
not really concerned with performance and stability of their code".

Here's a news flash for you - bugs happen, no matter how much testing is done
on something.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
