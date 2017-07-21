From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Fri, 21 Jul 2017 18:34:16 +0000
Message-ID: <bug-196405-13602-8M3mhc76wz@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41306 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751504AbdGUSeS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Jul 2017 14:34:18 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BB7EF28655
        for <linux-ext4@vger.kernel.org>; Fri, 21 Jul 2017 18:34:17 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #19 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
Ted, I think the right approach is to stop the ext4 kernel code from enabling
dir_nlink automatically, but continue to set it by default at format time for
new filesystems.  I suspect the number of users that want to get an error
returned when their directory grows large is very few, but at least they will
be able to turn off dir_nlink and/or create the filesystem without this feature
in the first place.  This will make the dir_nlink feature more consistent with
other features as well.

What I also just noticed is that e2fsck does not enable the dir_nlink feature
in the superblock in case i_links_count > EXT2_LINK_MAX.  I'm just working on a
patch for this.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
