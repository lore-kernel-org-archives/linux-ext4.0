From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Mon, 19 May 2014 12:46:35 +0000
Message-ID: <bug-76261-13602-fehDkLjo1O@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59890 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbaESMqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 08:46:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1CDE4202FE
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 12:46:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A7F9F2025B
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 12:46:35 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #13 from Theodore Tso <tytso@mit.edu> ---
Well, let's gather some data.  In android_reboot.c can you add the following:

static void get_debug_mem(void)
{
    int fd, cnt = 0;
    fd = open("/proc/sysrq-trigger", O_WRONLY);
    if (fd < 0) {
        return;
    }
    write(fd, "m", 1);
    close(fd);
}

And then in android reboot.c, make the beginning of the function read as
follows:

{
    get_debug_info();
    sync;
    get_debug_info();
    sync;
    get_debug_info();
    sync;
    get_debug_info();
    remount_ro();
    ...

And then send the output in the kmesg?

That should give us information about what might be going on.  It's
possible that get_nr_dirty_pages() or some other part of the machinery
used by fs/fs-writeback.c's writeback_inodes_sb() is somehow
incorrectly not syncing all of the dirty pages.

The other possibility is that the sync() system call is supposed to
send out to disk at least as many dirty pages as were present at the
time of the sync() system call was issued, but it is ***not*** a data
integrity operation.  Looking at the high level code, the main concern
of that codepath is to make sure that sync() would eventually return,
and not loop forever, even if some other user process was constantly
dirtying pages.  It simply wasn't intended for the use case that
Android is trying to use it for.

>From my reading of the VFS writeback code, it's possible that if there
were pages getting dirtied at the time of the sync() system call, that
some of the pages that were dirtied after sync() system call was
issued would be sent out to disk, but some of the older pages that
were dirtied before sync() system call might not make it out to disk.

Is it possible for you to enable ftrace on your kernel?  It might be
useful to see if in fact there is any attempts to be writing to one or
more file systems at the time when android_reboot() gets called, and
the kernel tracing facilities might help you accomplish that.

                                               - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
