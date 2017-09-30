From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197069] systemd service with ProtectHome=yes causes ELOOP when
 accessing /home
Date: Sat, 30 Sep 2017 01:07:48 +0000
Message-ID: <bug-197069-13602-aEUzXoAQI6@https.bugzilla.kernel.org/>
References: <bug-197069-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50816 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752579AbdI3BHt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Sep 2017 21:07:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DC6C5298B7
        for <linux-ext4@vger.kernel.org>; Sat, 30 Sep 2017 01:07:48 +0000 (UTC)
In-Reply-To: <bug-197069-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197069

Jack (xxjack12xx@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|INVALID                     |---

--- Comment #3 from Jack (xxjack12xx@gmail.com) ---
Before this commit into the -lt branch, autofs and symlinked /home worked fine.
After that commit, this issue appeared.

commit 839d42687dfce0ed0ea2c6bd8d707cc0e276fbe7
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Fri Jan 20 18:28:35 2017 +1300

    mnt: Tuck mounts under others instead of creating shadow/side mounts.

    commit 1064f874abc0d05eeed8993815f584d847b72486 upstream.

    Ever since mount propagation was introduced in cases where a mount in
    propagated to parent mount mountpoint pair that is already in use the
    code has placed the new mount behind the old mount in the mount hash
    table.

    This implementation detail is problematic as it allows creating
    arbitrary length mount hash chains.

    Furthermore it invalidates the constraint maintained elsewhere in the
    mount code that a parent mount and a mountpoint pair will have exactly
    one mount upon them.  Making it hard to deal with and to talk about
    this special case in the mount code.

    Modify mount propagation to notice when there is already a mount at
    the parent mount and mountpoint where a new mount is propagating to
    and place that preexisting mount on top of the new mount.

    Modify unmount propagation to notice when a mount that is being
    unmounted has another mount on top of it (and no other children), and
    to replace the unmounted mount with the mount on top of it.

    Move the MNT_UMUONT test from __lookup_mnt_last into
    __propagate_umount as that is the only call of __lookup_mnt_last where
    MNT_UMOUNT may be set on any mount visible in the mount hash table.

    These modifications allow:
     - __lookup_mnt_last to be removed.
     - attach_shadows to be renamed __attach_mnt and its shadow
       handling to be removed.
     - commit_tree to be simplified
     - copy_tree to be simplified

    The result is an easier to understand tree of mounts that does not
    allow creation of arbitrary length hash chains in the mount hash table.

    The result is also a very slight userspace visible difference in semantics.
    The following two cases now behave identically, where before order
    mattered:

    case 1: (explicit user action)
            B is a slave of A
            mount something on A/a , it will propagate to B/a
            and than mount something on B/a

    case 2: (tucked mount)
            B is a slave of A
            mount something on B/a
            and than mount something on A/a

    Histroically umount A/a would fail in case 1 and succeed in case 2.
    Now umount A/a succeeds in both configurations.

    This very small change in semantics appears if anything to be a bug
    fix to me and my survey of userspace leads me to believe that no programs
    will notice or care of this subtle semantic change.

    v2: Updated to mnt_change_mountpoint to not call dput or mntput
    and instead to decrement the counts directly.  It is guaranteed
    that there will be other references when mnt_change_mountpoint is
    called so this is safe.

    v3: Moved put_mountpoint under mount_lock in attach_recursive_mnt
        As the locking in fs/namespace.c changed between v2 and v3.

    v4: Reworked the logic in propagate_mount_busy and __propagate_umount
        that detects when a mount completely covers another mount.

    v5: Removed unnecessary tests whose result is alwasy true in
        find_topper and attach_recursive_mnt.

    v6: Document the user space visible semantic difference.

    Fixes: b90fa9ae8f51 ("[PATCH] shared mount handling: bind and rbind")
    Tested-by: Andrei Vagin <avagin@virtuozzo.com>
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
