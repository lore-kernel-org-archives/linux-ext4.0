Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39544 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbeKOOnm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 09:43:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 86D6A2C2AF
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2018 04:37:27 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 15 Nov 2018 04:37:28 +0000
Message-ID: <bug-201685-13602-aONlURqUY9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso (tytso@mit.edu) ---
I'm using a 4.19.0 based kernel (with some ext4 patches for the 4.20 mainline)
and I'm not noticing any file system problems.   I'm running a Dell XPS 13 with
an NVME SSD, and Debian testing as my userspace.

It's hard to do anything with a "my file system is corrupted" report without
any kind of reliable reproduction information.   Remember that file system
corruptions can be caused by any number of things --- buggy device drivers,
buggy Nvidia binary modules that dereference wild pointers and randomly corrupt
kernel memory, RAID code if you are using RAID, etc., etc.

Also, the symptoms reported by Claude and Jason are very different.  Claude has
reported that a data block in a shared library file has gotten corrupted. 
Jason has reported that file system metadata corruption.   This could very well
be coming from different root causes.

So it's better with these sorts of things to file separate bugs, and to include
detailed hardware configuration details, kernel configuration, dumpe2fs outputs
of the file system in question, as well as e2fsck logs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
