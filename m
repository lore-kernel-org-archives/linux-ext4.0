From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 16:47:05 GMT
Message-ID: <200910291647.n9TGl5Q8028750@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45705 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbZJ2QrA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 12:47:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TGl5x5028751
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 16:47:05 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #141 from Eric Sandeen <sandeen@redhat.com>  2009-10-29 16:47:01 ---
Maxim, I'm reproducing it like this:

#!/bin/bash

echo "clearing & reinstalling modules"

mkdir -p /tmp/modules
rm -rf /tmp/modules/*

mount /dev/sdb4 /mnt/test2/
cd /mnt/test2/linux-2.6
while true; do
    make -j2 MODLIB=/tmp/modules modules_install
done

where /mnt/test2/linux-2.6 is just a recent kernel tree.

I then cut power to the box in the middle of the install, reboot, and see what
shape I'm in.

I had been cutting power after a random amount of time but I think it's
probably best to catch it while the modules are being actively copied over,
rather than say while depmod is running, but I'm not 100% certain about that.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
