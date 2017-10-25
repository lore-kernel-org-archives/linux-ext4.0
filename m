From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] renameat2 rename_noreplace
Date: Wed, 25 Oct 2017 08:59:28 +0000
Message-ID: <bug-197045-13602-6HFsee55lc@https.bugzilla.kernel.org/>
References: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58738 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932246AbdJYI73 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 25 Oct 2017 04:59:29 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4F56628516
        for <linux-ext4@vger.kernel.org>; Wed, 25 Oct 2017 08:59:29 +0000 (UTC)
In-Reply-To: <bug-197045-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

--- Comment #14 from Theodore Tso (tytso@mit.edu) ---
Michael Halcrow (the original author of ecryptfs, and who has jokingly referred
to his work on ext4 encryption as his apology for ecryptfs :-) and I have
talked to Tyler about Ubuntu switching to ext4 encryption.   This is really
going to be a matter of prioritizing work at Canonical; so user feature
requests (especially requests from paying users :-) would be helpful.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
