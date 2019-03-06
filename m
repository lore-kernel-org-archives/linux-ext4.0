Return-Path: <SRS0=J2/x=RJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDE1C43381
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 13:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B609F20675
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 13:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfCFN3l (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Mar 2019 08:29:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:40630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727304AbfCFN3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Mar 2019 08:29:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 340A7BC60;
        Wed,  6 Mar 2019 13:29:40 +0000 (UTC)
Date:   Wed, 6 Mar 2019 14:29:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocky" <rafael.j.wysocki@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [question] panic() during reboot -f (reboot syscall)
Message-ID: <20190306132938.hzyb7gee5actx3l3@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170421 (1.8.2)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

I wonder if it is "normal" to get panic() when the system is rebooted
using "reboot -f". I looks a bit weird to me.

In our case, the panic() was triggered from ext4 filesystem code
that was mounted with "errors=panic"

  crash> bt
  PID: 3984   TASK: ffff887db1f6c180  CPU: 32  COMMAND: "bash"
  #0 [ffff887e637bf9a8] machine_kexec at ffffffff81059c5c
  #1 [ffff887e637bf9f8] __crash_kexec at ffffffff81119e0a
  #2 [ffff887e637bfab8] panic at ffffffff81193c31
  #3 [ffff887e637bfb30] ext4_handle_error at ffffffffa0229faa [ext4]
  #4 [ffff887e637bfb40] __ext4_error_inode at ffffffffa022a12a [ext4]
  #5 [ffff887e637bfbe0] __ext4_get_inode_loc at ffffffffa02096a5 [ext4]
  #6 [ffff887e637bfc40] ext4_iget at ffffffffa020c028 [ext4]
  #7 [ffff887e637bfcc0] ext4_lookup at ffffffffa0216ca0 [ext4]
  #8 [ffff887e637bfce8] lookup_real at ffffffff81218e3f
  #9 [ffff887e637bfd00] __lookup_hash at ffffffff8121916f
  #10 [ffff887e637bfd20] walk_component at ffffffff8121b50f
  #11 [ffff887e637bfd70] path_lookupat at ffffffff8121ca30
  #12 [ffff887e637bfd98] filename_lookup at ffffffff8121e58c
  #13 [ffff887e637bfe98] vfs_fstatat at ffffffff81214549
  #14 [ffff887e637bfed8] SYSC_newstat at ffffffff812149ca
  #15 [ffff887e637bff50] entry_SYSCALL_64_fastpath at ffffffff8161de61
      RIP: 00007f9db8d3ebe5  RSP: 00007ffda081cf68  RFLAGS: 00000246
      RAX: ffffffffffffffda  RBX: 0000000000000000  RCX: 00007f9db8d3ebe5
      RDX: 00000000013c7fa0  RSI: 00000000013c7fa0  RDI: 00000000013c7f40
      RBP: 00007f9db943bee0   R8: 00000000013c7f40   R9: 00000000000b0000
      R10: 000000007af2c337  R11: 0000000000000246  R12: 00000000013c7fa0
      R13: 00000000013c7fa0  R14: 0000000000000008  R15: 00000000013c7f80
      ORIG_RAX: 0000000000000004  CS: 0033  SS: 002b


Now, "reboot -f" just calls the reboot() syscall. I do not see
anything that would stop processes. It even does not stop
other CPUs by purpose, see the commit cf7df378aa4ff7da
("reboot: rigrate shutdown/reboot to boot cpu").

But it shuts down devices very early, via:

  + kernel_restart()
    + kernel_restart_prepare()
      + blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
      + device_shutdown()

As a result, processes are still running. Filesystem code return
errors because the underlaying disk device was removed. It causes
panic() because "errors=panic" mount option.


My undestanding that userspace is reponsible for "clean" reboot.
The "reboot" command normally stops services, kill processes,
sync disks, umount filesystem before it calls the "reboot"
syscall.

By other words. It looks like the panic() is possible by design.
But it looks a bit weird. Any opinion?

Best Regards,
Petr
