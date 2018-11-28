Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55722 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbeK1QGB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 11:06:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 032432C0C2
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 05:05:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 05:05:40 +0000
Message-ID: <bug-201685-13602-L738sOFqW5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #59 from Theodore Tso (tytso@mit.edu) ---
Created attachment 279687
  --> https://bugzilla.kernel.org/attachment.cgi?id=279687&action=edit
Ext4 from 4.18

I'm pretty sure the problem is not in the ext4 changes between 4.18 and 4.19,
since the changes are all quite innocuous (and if it was in the ext4 code, the
regression testing really should have picked it up).

But just to rule things out, I've uploaded the contents of fs/ext4 from 4.18.  
I've verified it can be transplanted on top of 4.19 kernel.   Could the people
who are experiencing problems with 4.19 try building a kernel with the 4.18
fs/ext4 directory?   If you still see problems, then the problem has to be
elsewhere.   If you don't, then we can take a closer look at the ext4 changes
(although I'd then be really puzzled why it's only showing up for some folks,
but not others).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
