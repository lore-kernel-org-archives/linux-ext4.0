Return-Path: <SRS0=Xbv+=M6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43930 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727299AbeJRKAh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Oct 2018 06:00:37 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4574C28A10
        for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2018 02:02:04 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201461] ext4 journal stalls write system call
Date: Thu, 18 Oct 2018 02:02:04 +0000
Message-ID: <bug-201461-13602-OCrvpuDGp7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201461-13602@https.bugzilla.kernel.org/>
References: <bug-201461-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201461

--- Comment #2 from zhenbianshu@foxmail.com ---
(In reply to Theodore Tso from comment #1)
> It shouldn't be the case that the journal's data=ordered writeback would be
> taking the i_data semaphore for writing.   
> 
> I'm guessing what is happening is that journal is causing a lot of I/O
> operations because of data=ordered mode (e.g., not data=writeback), and this
> is delaying a read which a writeback thread was trying to do while it was
> holding a write lock on the inode's semaphore.

can you please show me the related source code of writeback holding a write
lock?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
