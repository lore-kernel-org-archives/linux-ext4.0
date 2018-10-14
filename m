Return-Path: <SRS0=nu1L=M2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50706 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbeJNPJ1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 Oct 2018 11:09:27 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B5C3B2A4D8
        for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2018 07:29:22 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 200681] [inline_data] read() does not see what write() has just
 written through different FD in the same thread
Date: Sun, 14 Oct 2018 07:29:22 +0000
Message-ID: <bug-200681-13602-VxCfgeoWgo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200681-13602@https.bugzilla.kernel.org/>
References: <bug-200681-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=200681

--- Comment #9 from Anatoly Trosinenko (anatoly.trosinenko@gmail.com) ---
> I'm curious how you found this bug; were you deliberately using a 1k block
> size, or were you trying to use inline_data with very small file systems?

Frankly speaking, I have not stumbled upon this bug in real life --- just done
some FS fuzzing and for improving performance used smaller FS images. Maybe
smaller images have larger probability of triggering some bugs in my setup, too
(now I know why :) ). But inline_data (as well as other extended options) were
enabled deliberately, of course, supposing they are less stable than the core
features.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
