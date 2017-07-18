From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 23:12:58 +0000
Message-ID: <bug-196405-13602-8qgGFGMIWw@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55604 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751987AbdGRXM7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 19:12:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3A85628607
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 23:12:59 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #7 from Paul Eggert (eggert@cs.ucla.edu) ---
Created attachment 257593
  --> https://bugzilla.kernel.org/attachment.cgi?id=257593&action=edit
sample program illustrating how ext4 st_nlink behavior breaks glibc

Run this program in an empty ext4 directory to illustrate the problem: fts will
misbehave and will not find the two files "needle" in the large-directory
haystack.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
