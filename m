From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 21:54:52 +0000
Message-ID: <bug-196405-13602-AfTk7lpbDT@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38656 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752191AbdGRVy7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 17:54:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2C070285C2
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 21:54:59 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #4 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
The limit is implemented as < 65000, which was somewhat below the hard limit of
the ext4_inode.i_links_count __u16 field of 65535.  There is no hard reason for
65000 except to allow some margin for detecting overflow, and reserved values
if there was a need.  I don't think it makes a big practical difference whether
directory link counts are accurate up to 65000 or 65534 subdirectories, since
very few systems have this many subdirectories.

In theory, we could add an i_links_count_hi field to extend this to a 32-bit
value, but it isn't clear if there is a big benefit from doing this?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
