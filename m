From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 25 Jul 2017 09:05:59 +0000
Message-ID: <bug-196405-13602-mHgHf1tdbZ@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50562 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750860AbdGYJGA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Jul 2017 05:06:00 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3A68528587
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jul 2017 09:06:00 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #27 from Paul Eggert (eggert@cs.ucla.edu) ---
(In reply to Theodore Tso from comment #22)
> Paul is asserting that there is vast
> amount of breakage because ext4 can return an st_nlinks value of 1 on a
> directory, to the extent that he believes we should withdrawing the
> dir_nlinks feature.

I think this gets my most recent proposal backwards. At the end of Comment 17,
I proposed that the ext4 code act as if dir_nlink is always set. That's what
the code has been doing for a decade anyway. All that's missing is
documentation which says "the dir_nlink setting is irrelevant, and the file
system always acts as if dir_nlink is set", or words to that effect.

Although in hindsight perhaps the dir_nlink flag should have been implemented
properly, it wasn't and there's little point to implementing it properly now:
every application using ext4 must work with the current behavior anyway.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
