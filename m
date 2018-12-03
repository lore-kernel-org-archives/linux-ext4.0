Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45986 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLCBsf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 20:48:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 75FEA2A716
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 01:48:33 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 01:48:30 +0000
Message-ID: <bug-201685-13602-B369hVghjb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #178 from Sune Mølgaard (molgaard@gmail.com) ---
Hi Theodore,

I am not much of a kernel developer, let alone and FS one, so your guesses
would be vastly better founded than mine.

I could imagine, though, that a combination of GCC version, .config and,
possibly, the creation time (kernel version-wise) of the FSs in question, could
create a sort of "cocktail effect". For my part, none of my FSs are < at least
a year old.

FWIW, I started seeing the problem specifically with 4.19.3 (4.19.0 being good,
and built with 8.2.0-7), but that was after skipping 4.19.[12].

I note that the first Ubuntu kernel-ppa kernel the be built with 8.2.0-9 was
4.19.1, so if my ongoing bisect ends without any triggering of the bug I see, I
shall try kernel-ppa 4.19.1 - if that exhibits the bug, then that further
points to GCC, but as you say, perhaps specifically for the Ubuntu kernels.

Now, as someone else stated somewhere, the only things that kernel-ppa patches,
are some Ubuntu-specific build and package structure, as well as .config hte
lst part being available at
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.19.1/0006-configs-based-on-Ubuntu-4.19.0-4.5.patch
.

As promised above, I have written the kernel-ppa team lead, Bradd Figg, and I
would expect him and his team to be better at pinpointing which combination of
GCC 8.2.0-9 and .config options might be problematic, but if they find that the
problem goes away with a GCC upgrade, they might opt for letting that be it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
