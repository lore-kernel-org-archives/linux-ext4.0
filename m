From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] renameat2 rename_noreplace
Date: Tue, 24 Oct 2017 12:29:42 +0000
Message-ID: <bug-197045-13602-0WYLoK3uXE@https.bugzilla.kernel.org/>
References: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34696 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932267AbdJXM3n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 24 Oct 2017 08:29:43 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D757328414
        for <linux-ext4@vger.kernel.org>; Tue, 24 Oct 2017 12:29:42 +0000 (UTC)
In-Reply-To: <bug-197045-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

--- Comment #3 from Elvis Stansvik (elvstone@gmail.com) ---
I'm hit by this on 4.10 a well (the default kernel on Ubuntu 16.04).

I attached a full test case showing.

Example run:


> [estan@newton renameat2tc]$ gcc renameat2.c 
> [estan@newton renameat2tc]$ touch foo
> [estan@newton renameat2tc]$ ./a.out foo bar
> Invalid argument
> [estan@newton renameat2tc]$ uname -a
> Linux newton 4.10.0-37-generic #41~16.04.1-Ubuntu SMP Fri Oct 6 22:42:59 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> [estan@newton renameat2tc]$ mount | grep " / "
> /dev/sda1 on / type ext4 (rw,noatime,discard,errors=remount-ro,data=ordered)

The reason I discovered it was that Qt recently started using this syscall,
which in turn made Qt Creator (a Qt application) fail to write its config
files.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
