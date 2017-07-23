From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Sun, 23 Jul 2017 22:55:14 +0000
Message-ID: <bug-196405-13602-0nvcojS9I8@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47918 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751361AbdGWWzP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 18:55:15 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 54B3F284B2
        for <linux-ext4@vger.kernel.org>; Sun, 23 Jul 2017 22:55:15 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #24 from Theodore Tso (tytso@mit.edu) ---
An update to e2fsprogs to clarify how dir_nlink works in the ext4 man
page.

                                - Ted

commit 7d8f358cdce948df57b1001b9c278f33519afa86
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jul 23 18:51:22 2017 -0400

    Clarify how the description of the dir_nlink feature in the ext4 man page

    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index c1e67abbc..3511dae62 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -69,7 +69,12 @@ ext2 file systems.
 .TP
 .B dir_nlink
 .br
-This ext4 feature allows more than 65000 subdirectories per directory.
+Normally ext4 allows an inode to have no more than 65,000 hard links.
+This applies to files as well as directories, which means that there can
+be no more than 64,998 subdirectories in a directory (because each of
+the '..' entries counts as a hard link).  This feature lifts this limit
+by causing ext4 to use a links count of 1 to indicate that the number of
+hard links to a directory is not known.
 .TP
 .B encrypt
 .br

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
