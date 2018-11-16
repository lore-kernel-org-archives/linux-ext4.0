Return-Path: <SRS0=OKzU=N3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39626 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725729AbeKQFR3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 17 Nov 2018 00:17:29 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2386829A09
        for <linux-ext4@vger.kernel.org>; Fri, 16 Nov 2018 19:03:52 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 16 Nov 2018 19:03:51 +0000
Message-ID: <bug-201685-13602-ItIAHrz1xu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #6 from Theodore Tso (tytso@mit.edu) ---
Please send detailed information about your hardware (lspci -v and dmesg while
it is booting would be helpful).   Also please send the results of running
dumpe2fs on the file system, and the kernel logs when file system operations
started returning "Structure needs cleaning".   I want to see if there are any
other kernel messages in and around the ext4 error messages that will be in the
kernel logs.    Also please send me the fsck logs, and what sort of workload
(what programs) you have running on your system.   Also, do you do anything
unusual on your machine; do you typically do clean shutdowns, or do you just do
forced power-offs?   Are you regularly running into a large amount of memory
pressure (e.g., are you regularly using a large percentage of the physical
memory available on your system.)

This is going to end up being a process of elimination.   4.19 works for me.  
I'm using a 2018 Dell XPS 13, Model 9370, with 16GB of memory and I run a
typical kernel developer workload.   We also run a large number of ext4
regression testing, which generally happens on KVM for one developer, and I use
Google Compute Engine for my tests.   None of this detected any problems before
4.19 was released.    So the question then is --- what makes people who are
experiencing difficulties different from my development laptop (which also has
an Intel board, and an SSD connected using NVMe) from those who are seeing
problems?  This is why getting lots of details about the precise hardware
configuration is going to be critically important.

In the ideal world we would come up with a clean, simple, reliable reproducer. 
Then we can experiment and see if the reliable reproducer continues to
reproduce on different hardware, etc.   

Finally, since in order to figure things out we may need a lot of detail about
the hardware, the software, and the applications running on each of the systems
where people are seeing problems, it's helpful if new people upload all of this
information onto new kernel bugzilla issues, and then mention the kernel
bugzilla issue here, so people can follow the links.

I'll note that a few years ago, we had a mysterious "ext4 failure" that
ultimately turned out to be a Intel virtualization hardware bug, and it was the
*host* version that mattered, not the *guest* kernel version that mattered. 
Worse, it was fixed in the very next vesion of the kernel, and so it was only
people using Debian host kernels that ran into troubles --- but **only** if
they were using a specific Intel chipset and Intel CPU generation.   Everyone
kept on swearing up and down it was an ext4 bug, and there were many angry
people arguing this on bugzilla.   Ultimately, it was a problem caused by a
hardware bug, and a kernel workaround that was in 3.18 but not in 3.17, and
Debian hadn't noticed they needed to backport the kernel workaround....   And
because everyone was *certain* that the host kernel version didn't matter ---
after all, it was *obviously* an ext4 bug in the guest kernel --- they didn't
report it, and that made figuring out what the problem was (it took over a
year) much, Much, MUCH harder.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
