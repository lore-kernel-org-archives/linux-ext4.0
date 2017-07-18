From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 19:41:01 +0000
Message-ID: <bug-196405-13602-VReWEVAIbl@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45310 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751402AbdGRTlC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 15:41:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 98DC226E4E
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 19:41:02 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #1 from Theodore Tso (tytso@mit.edu) ---
On Mon, Jul 17, 2017 at 09:23:44PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> See the following shell transcript, run in an ext4 directory, for an
> illustration of the bug. The first four commands set things up. The 5th
> command
> 'mkdir d/64998' calls 'mkdir("d/64998, 0777)' and succeeds. The 6th command
> shows that d's resulting st_nlink value is 1, which is incorrect; it should
> be
> 65000. I discovered this bug in Fedora 26, which runs Linux 4.11.10; from
> inspecting the source it appears the bug is still there in 4.13-rc1.

This is actually working as intended.  In order to support a large
number of directories, when we have a 16-bit link count field, we use
a link count of 1 to mean, "lots".

If you don't want this behavior because strict POSIX compliance is
preferable to failing with ENOSPC when you hit that overflow
condition, you can create the file system with the dir_nlink feature
turned off.

I will note that various userspace utilities that try to optimize
directory walking by depending on the directory's link count to
understand when they have found all of the subdirectories know that
directory link count of 1 means "lots".  This is why a link count of 1
was chosen.

                                                - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
