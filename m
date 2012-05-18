From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43260] ftruncate locks up when used with direct IO on ext4
Date: Fri, 18 May 2012 02:06:42 +0000 (UTC)
Message-ID: <20120518020642.271CE11FCFB@bugzilla.kernel.org>
References: <bug-43260-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030461Ab2ERCGp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2012 22:06:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0A787205A4
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2012 02:06:44 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 2CF4D20592
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2012 02:06:42 +0000 (UTC)
In-Reply-To: <bug-43260-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43260


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2012-05-18 02:06:41 ---
commit details:

commit 8c0bec2151a47906bf779c6715a10ce04453ab77
Author: Jiaying Zhang <jiayingz@google.com>
Date:   Wed Aug 31 11:50:51 2011 -0400

    ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining

    The i_mutex lock and flush_completed_IO() added by commit 2581fdc810
    in ext4_evict_inode() causes lockdep complaining about potential
    deadlock in several places.  In most/all of these LOCKDEP complaints
    it looks like it's a false positive, since many of the potential
    circular locking cases can't take place by the time the
    ext4_evict_inode() is called; but since at the very least it may mask
    real problems, we need to address this.

    This change removes the flush_completed_IO() and i_mutex lock in
    ext4_evict_inode().  Instead, we take a different approach to resolve
    the software lockup that commit 2581fdc810 intends to fix.  Rather
    than having ext4-dio-unwritten thread wait for grabing the i_mutex
    lock of an inode, we use mutex_trylock() instead, and simply requeue
    the work item if we fail to grab the inode's i_mutex lock.

    This should speed up work queue processing in general and also
    prevents the following deadlock scenario: During page fault,
    shrink_icache_memory is called that in turn evicts another inode B.
    Inode B has some pending io_end work so it calls ext4_ioend_wait()
    that waits for inode B's i_ioend_count to become zero.  However, inode
    B's ioend work was queued behind some of inode A's ioend work on the
    same cpu's ext4-dio-unwritten workqueue.  As the ext4-dio-unwritten
    thread on that cpu is processing inode A's ioend work, it tries to
    grab inode A's i_mutex lock.  Since the i_mutex lock of inode A is
    still hold before the page fault happened, we enter a deadlock.

    Signed-off-by: Jiaying Zhang <jiayingz@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I tested on the 3.2.10 fedora kernel, though, and it didn't lock up (tried many
times):

# rm -f lockfile; ./ftruncate-test lockfile
This might lock up..
It didn't lock up.


Can you lock it up, and do a sysrq-w and maybe sysrq-d and attach the resulting
dmesg?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
