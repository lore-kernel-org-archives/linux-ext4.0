From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Mon, 08 Aug 2016 20:30:00 +0000
Message-ID: <bug-151491-13602-RlWpp3StwU@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51188 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbcHHUaE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Aug 2016 16:30:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ED74C2026F
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2016 20:30:02 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CC41C20253
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2016 20:30:00 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #2 from Matthew L. Martin <mlmartin@clearsky-data.com> ---
I believe that I have confirmed that this fault is not present in linux 4.7.
After running the reproduction script for over three hours I have not seen a
difference between the usage reported by du and df:

# df -h /mnt/hdd_sd[gh]; du -hs  /mnt/hdd_sd[gh]
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdg        5.5T   20G  5.4T   1% /mnt/hdd_sdg
/dev/sdh        5.5T   20G  5.4T   1% /mnt/hdd_sdh
20G    /mnt/hdd_sdg
20G    /mnt/hdd_sdh

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
