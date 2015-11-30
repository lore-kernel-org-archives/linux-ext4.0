From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] New: Stuck on mb_cache_spinlock
Date: Mon, 30 Nov 2015 16:36:08 +0000
Message-ID: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40348 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbbK3QgO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 11:36:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EB2EC20592
	for <linux-ext4@vger.kernel.org>; Mon, 30 Nov 2015 16:36:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E85A720576
	for <linux-ext4@vger.kernel.org>; Mon, 30 Nov 2015 16:36:09 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

            Bug ID: 108631
           Summary: Stuck on mb_cache_spinlock
           Product: File System
           Version: 2.5
    Kernel Version: 4.3.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: apolyakov@beget.ru
        Regression: No

We use POSIX ACL's extensively on our systems and we're experiencing
mbcache-related hangs recently. 
My amature analysis of the problem follows: when it happens that memory gets
low mb_cache_shrink_* functions run acquiring the mb_cache_spinlock, which in
turn leads to mb_cache_entry_alloc() blocking and CPUs getting stuck for
seconds (2015-11-25T22:16:25.326266+03:00 iohost [1069489.325447] NMI watchdog:
BUG: soft lockup - CPU#15 stuck for 22s! [sh:17142])

Here're some excerpts from netconsole logs:

CPU0
2015-11-25T22:16:33.056273+03:00 somehost [1069497.048211] 
[<ffffffffa024e739>] ? ext4_xattr_cache_insert+0x19/0x60
2015-11-25T22:16:33.056537+03:00 somehost [1069497.048481] 
[<ffffffffa024ff58>] ? ext4_xattr_get+0x168/0x200
2015-11-25T22:16:33.056828+03:00 somehost [1069497.048745] 
[<ffffffffa01b4ade>] ? generic_getxattr+0x3e/0x50
2015-11-25T22:16:33.057076+03:00 somehost [1069497.049006] 
[<ffffffffa0291714>] ? cap_inode_need_killpriv+0x24/0x30
2015-11-25T22:16:33.057455+03:00 somehost [1069497.049266] 
[<ffffffffa0294769>] ? security_inode_need_killpriv+0x29/0x40
2015-11-25T22:16:33.057940+03:00 somehost [1069497.049622] 
[<ffffffffa01ac6c4>] ? dentry_needs_remove_privs.part.6+0x14/0x30
2015-11-25T22:16:33.058176+03:00 somehost [1069497.050123] 
[<ffffffffa01ac70c>] ? file_remove_privs+0x1c/0x80
2015-11-25T22:16:33.058438+03:00 somehost [1069497.050384] 
[<ffffffffa0254d6d>] ? __ext4_set_acl+0x2ad/0x330
2015-11-25T22:16:33.058704+03:00 somehost [1069497.050645] 
[<ffffffffa012e36e>] ? __generic_file_write_iter+0x5e/0x1d0
2015-11-25T22:16:33.058975+03:00 somehost [1069497.050912] 
[<ffffffffa02f7f36>] ? string.isra.2+0x36/0xc0
2015-11-25T22:16:33.059236+03:00 somehost [1069497.051177] 
[<ffffffffa020ab31>] ? ext4_file_write_iter+0xe1/0x420
2015-11-25T22:16:33.059507+03:00 somehost [1069497.051440] 
[<ffffffffa02f9d49>] ? snprintf+0x39/0x40
2015-11-25T22:16:33.059792+03:00 somehost [1069497.051701] 
[<ffffffffa01d301a>] ? subbuf_start_callback+0xa/0xe0
2015-11-25T22:16:33.060038+03:00 somehost [1069497.051967] 
[<ffffffffa00fbde6>] ? relay_switch_subbuf+0xd6/0x160
2015-11-25T22:16:33.060304+03:00 somehost [1069497.052230] 
[<ffffffffa0195044>] ? __vfs_write+0xa4/0xf0
2015-11-25T22:16:33.060564+03:00 somehost [1069497.052489] 
[<ffffffffa01956a9>] ? vfs_write+0x99/0x1d0
2015-11-25T22:16:33.060815+03:00 somehost [1069497.052749] 
[<ffffffffa0195fad>] ? SyS_write+0x3d/0xa0
2015-11-25T22:16:33.061073+03:00 somehost [1069497.053013] 
[<ffffffffa064dd57>] ? entry_SYSCALL_64_fastpath+0x12/0x6a

CPU8
2015-11-25T22:16:37.166151+03:00 somehost [1069501.154112] 
[<ffffffffa01e124c>] ? mb_cache_shrink_count+0xc/0xa0
2015-11-25T22:16:37.166419+03:00 somehost [1069501.154375] 
[<ffffffffa013e73a>] ? shrink_slab.part.15+0x11a/0x350
2015-11-25T22:16:37.166685+03:00 somehost [1069501.154637] 
[<ffffffffa00e5f38>] ? css_next_descendant_pre+0x48/0x60
2015-11-25T22:16:37.166945+03:00 somehost [1069501.154899] 
[<ffffffffa01413d6>] ? shrink_zone+0x296/0x2a0
2015-11-25T22:16:37.167224+03:00 somehost [1069501.155159] 
[<ffffffffa014223b>] ? kswapd+0x4fb/0x8e0
2015-11-25T22:16:37.167464+03:00 somehost [1069501.155419] 
[<ffffffffa0141d40>] ? mem_cgroup_shrink_node_zone+0x150/0x150
2015-11-25T22:16:37.167760+03:00 somehost [1069501.155684] 
[<ffffffffa0094be8>] ? kthread+0xb8/0xd0
2015-11-25T22:16:37.168001+03:00 somehost [1069501.155950] 
[<ffffffffa0094b30>] ? kthread_worker_fn+0x140/0x140
2015-11-25T22:16:37.168252+03:00 somehost [1069501.156212] 
[<ffffffffa064e09f>] ? ret_from_fork+0x3f/0x70
2015-11-25T22:16:37.168512+03:00 somehost [1069501.156471] 
[<ffffffffa0094b30>] ? kthread_worker_fn+0x140/0x140

CPU13
2015-11-25T22:16:37.310698+03:00 somehost [1069501.298509] 
[<ffffffffa01e124c>] ? mb_cache_shrink_count+0xc/0xa0
2015-11-25T22:16:37.310969+03:00 somehost [1069501.298776] 
[<ffffffffa013e73a>] ? shrink_slab.part.15+0x11a/0x350
2015-11-25T22:16:37.311246+03:00 somehost [1069501.299045] 
[<ffffffffa00e5f38>] ? css_next_descendant_pre+0x48/0x60
2015-11-25T22:16:37.311502+03:00 somehost [1069501.299311] 
[<ffffffffa01413d6>] ? shrink_zone+0x296/0x2a0
2015-11-25T22:16:37.311755+03:00 somehost [1069501.299574] 
[<ffffffffa014223b>] ? kswapd+0x4fb/0x8e0
2015-11-25T22:16:37.312029+03:00 somehost [1069501.299836] 
[<ffffffffa0141d40>] ? mem_cgroup_shrink_node_zone+0x150/0x150
2015-11-25T22:16:37.312292+03:00 somehost [1069501.300107] 
[<ffffffffa0094be8>] ? kthread+0xb8/0xd0
2015-11-25T22:16:37.312561+03:00 somehost [1069501.300370] 
[<ffffffffa0094b30>] ? kthread_worker_fn+0x140/0x140
2015-11-25T22:16:37.312857+03:00 somehost [1069501.300640] 
[<ffffffffa064e09f>] ? ret_from_fork+0x3f/0x70
2015-11-25T22:16:37.313096+03:00 somehost [1069501.300905] 
[<ffffffffa0094b30>] ? kthread_worker_fn+0x140/0x140

CPU15
2015-11-25T22:16:53.337301+03:00 somehost [1069517.309523] 
[<ffffffffa01e167f>] ? mb_cache_entry_alloc+0x1f/0x1d0
2015-11-25T22:16:53.337568+03:00 somehost [1069517.309793] 
[<ffffffffa024e739>] ? ext4_xattr_cache_insert+0x19/0x60
2015-11-25T22:16:53.337829+03:00 somehost [1069517.310060] 
[<ffffffffa024ff58>] ? ext4_xattr_get+0x168/0x200
2015-11-25T22:16:53.338103+03:00 somehost [1069517.310327] 
[<ffffffffa01b4ade>] ? generic_getxattr+0x3e/0x50
2015-11-25T22:16:53.338367+03:00 somehost [1069517.310593] 
[<ffffffffa0292052>] ? get_vfs_caps_from_disk+0x52/0xf0
2015-11-25T22:16:53.338630+03:00 somehost [1069517.310859] 
[<ffffffffa02922e5>] ? cap_bprm_set_creds+0x1f5/0x590
2015-11-25T22:16:53.338905+03:00 somehost [1069517.311125] 
[<ffffffffa0293af9>] ? security_bprm_set_creds+0x29/0x40
2015-11-25T22:16:53.339167+03:00 somehost [1069517.311393] 
[<ffffffffa019acbd>] ? prepare_binprm+0x6d/0x160
2015-11-25T22:16:53.339426+03:00 somehost [1069517.311657] 
[<ffffffffa019b6b3>] ? do_execveat_common+0x443/0x690
2015-11-25T22:16:53.339691+03:00 somehost [1069517.311921] 
[<ffffffffa019bb33>] ? SyS_execve+0x23/0x30
2015-11-25T22:16:53.339954+03:00 somehost [1069517.312187] 
[<ffffffffa064dfe5>] ? stub_execve+0x5/0x5
2015-11-25T22:16:53.340222+03:00 somehost [1069517.312450] 
[<ffffffffa064dd57>] ? entry_SYSCALL_64_fastpath+0x12/0x6a


I've not yet found a way to reproduce the problem reliably (this is
particularly hard as it only happens under load), but it's definitely connected
to shrinker being run simultaneosly with heavy filesystem activity (i.e.
running rsync / setfacl -R).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
