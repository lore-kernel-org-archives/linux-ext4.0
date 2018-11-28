Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34490 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbeK2Ju0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 04:50:26 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3DE392DFC6
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 22:47:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 22:47:13 +0000
Message-ID: <bug-201685-13602-lXPQIUvJiB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #68 from Jimmy.Jazz@gmx.net ---
# uname -a
Linux seal 4.18.0-rc1-radeon-00048-ge1333462e3-dirty #36 SMP PREEMPT Wed Nov 28
18:30:01 CET 2018 x86_64 AMD A10-5800K APU with Radeon(tm) HD Graphics
AuthenticAMD GNU/Linux

I finally run a promising kernel that compiles, doesn't crash and cares about
my filesystems.
4.18.0-rc1-radeon-00048-ge1333462e3-dirty could be a winner.

This time the backup file system dm-4 could be efficiently cured and dirvish
has done its work has expected.
I could compile with it the kernel 4.19.4 as J.Axboe asked me to.

@T.Tso, if you still have an interest in dmesg, fsck (quite impressive) output
with that kernel version, let me know.
Actually, the interaction between e2fsck 1.44.4 and kernel 4.18 differs from
4.19

An dmesg excerpt,
[12421.017028] EXT4-fs warning (device dm-4): kmmpd:191: kmmpd being stopped
since filesystem has been remounted as readonly.
[12434.457445] EXT4-fs warning (device dm-4): ext4_multi_mount_protect:325: MMP
interval 42 higher than expected, please wait.
The warning didn't show off with kernel 4.19 and remount is slower. No ext4
errors to see.

# git bisect log
git bisect start
# good: [94710cac0ef4ee177a63b5227664b38c95bbf703] Linux 4.18
git bisect good 94710cac0ef4ee177a63b5227664b38c95bbf703
# bad: [9ff01193a20d391e8dbce4403dd5ef87c7eaaca6] Linux 4.20-rc3
git bisect bad 9ff01193a20d391e8dbce4403dd5ef87c7eaaca6
# bad: [9ff01193a20d391e8dbce4403dd5ef87c7eaaca6] Linux 4.20-rc3
git bisect bad 9ff01193a20d391e8dbce4403dd5ef87c7eaaca6
# bad: [84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d] Linux 4.19
git bisect bad 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d
# bad: [f48097d294d6f76a38bf1a1cb579aa99ede44297] dt-bindings: display:
renesas: du: Document r8a77990 bindings
git bisect bad f48097d294d6f76a38bf1a1cb579aa99ede44297
# bad: [f48097d294d6f76a38bf1a1cb579aa99ede44297] dt-bindings: display:
renesas: du: Document r8a77990 bindings
git bisect bad f48097d294d6f76a38bf1a1cb579aa99ede44297
# bad: [54dbe75bbf1e189982516de179147208e90b5e45] Merge tag
'drm-next-2018-08-15' of git://anongit.freedesktop.org/drm/drm
git bisect bad 54dbe75bbf1e189982516de179147208e90b5e45
# bad: [0a957467c5fd46142bc9c52758ffc552d4c5e2f7] x86: i8259: Add missing
include file
git bisect bad 0a957467c5fd46142bc9c52758ffc552d4c5e2f7
# bad: [958f338e96f874a0d29442396d6adf9c1e17aa2d] Merge branch 'l1tf-final' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 958f338e96f874a0d29442396d6adf9c1e17aa2d
# bad: [85a0b791bc17f7a49280b33e2905d109c062a47b] Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect bad 85a0b791bc17f7a49280b33e2905d109c062a47b
# bad: [8603596a327c978534f5c45db135e6c36b4b1425] Merge branch
'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 8603596a327c978534f5c45db135e6c36b4b1425
# bad: [2406fb8d94fb17fee3ace0c09427c08825eacb16] Merge branch
'sched-urgent-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 2406fb8d94fb17fee3ace0c09427c08825eacb16
# bad: [cd23ac8ddb7be993f88bee893b89a8b4971c3651] rcu: Add comment to the last
sleep in the rcu tasks loop
git bisect bad cd23ac8ddb7be993f88bee893b89a8b4971c3651

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
