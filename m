Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53852 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbeK3S03 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 13:26:29 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 65C292FDFD
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 07:18:08 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 07:18:08 +0000
Message-ID: <bug-201685-13602-i3hxvaaSCq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #80 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Néstor A. Marchesini from comment #78)
> Well, guys, this seems to pass the test, after several reboots every several
> hours of use, I had no more corruptions of my four partitions mdadm raid1.
> The solution was to delete the ext4 folder from my kernel 4.19.5 and copy
> the ext4 folder from my previous kernel 4.18.20 and recompiling the tree
> 4.19.5.
> 
> $ uname -a
> Linux pc-user 4.19.5-gentoo #1 SMP PREEMPT Thu Nov 29 00:45:31 2018 x86_64
> AMD FX(tm)-8350 Eight-Core Processor AuthenticAMD GNU/Linux
> 
> I was comparing both folders /fs/ext4 of the 4.18.20 and 4.19.5 trees with
> meld and there are several modifications, unfortunately it exceeds my
> knowledge.
> At least on this side I affirm that the problem is gone, we will see it
> happen with later patches.

If you can bisect it as suggested in comment 79, please mind what Ted Tso has
said in comment 69, para. 2.

So, after you have hit a bad kernel, make sure that your fs is OK and do the
next step (compiling) with a known-as-good-kernel (4.18.20). Otherwise you
might get false negatives (wrong bads).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
