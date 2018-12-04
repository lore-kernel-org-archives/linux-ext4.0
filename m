Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54128 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbeLDVnd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 16:43:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E98522C7E9
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 21:43:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 21:43:30 +0000
Message-ID: <bug-201685-13602-xVRIooH3TV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #245 from Jens Axboe (axboe@kernel.dk) ---
I've only reproduced it that one time, but here's what I think is happening:

- Usually a request is queued, inserted into the blk-mq proper

- There's an optimization in place to attempt to issue to the driver directly
before doing that insert. If we fail because of some resource limitation, we
insert the request into blk-mq proper

- But if that failure did trigger, SCSI has already setup the command. This
means we now have a request in the regular blk-mq IO lists that is mergeable
with other commands, but where the SG tables for IO have already been setup.

- If we later do merge with this IO before dispatch, we'll only do DMA to the
original part of the request. This makes the rest very unhappy...

The case is different because from normal dispatch, if IO needs to be requeued,
it will NEVER be merged/changed after the fact. This means that we don't have
to release SG tables/mappings, we can simply reissue later.

This is just a theory... If I could reproduce more reliably, I'd verify it. I'm
going to spin a quick patch.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
