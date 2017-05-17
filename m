From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: jbd2: J_ASSERT(journal->j_free > 1) in jbd2_journal_next_log_block()
Date: Wed, 17 May 2017 13:58:40 +0300
Message-ID: <20170517105840.GG12906@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36288 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754275AbdEQK6r (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 May 2017 06:58:47 -0400
Received: by mail-wr0-f172.google.com with SMTP id l50so6322700wrc.3
        for <linux-ext4@vger.kernel.org>; Wed, 17 May 2017 03:58:46 -0700 (PDT)
Received: from localhost ([95.161.166.82])
        by smtp.gmail.com with ESMTPSA id 10sm322516lji.69.2017.05.17.03.58.43
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 May 2017 03:58:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone!

Recently I got next trace on one of machines (backtrace can be not in correct
order since it captured via netconsole):

  [7932653.070316] ------------[ cut here ]------------
  [7932653.070359] kernel BUG at fs/jbd2/journal.c:759!
  [7932653.070392] invalid opcode: 0000 [#1] SMP
  [7932653.070424] Modules linked in: ...
  [7932653.071108] CPU: 0 PID: 356 Comm: jbd2/md0-8 Not tainted 4.8.1 #1
  [7932653.071164] Hardware name: Supermicro Super Server/X10DRW-i, BIOS 1.1 08/13/2015
  [7932653.071222] task: ffff881ff1babfc0 task.stack: ffff881fef890000
   [<ffffffffa0454728>] jbd2_journal_next_log_block+0x68/0x70 [jbd2]
  [7932653.071258] RIP: 0010:[<ffffffffa0454728>]
  [7932653.071338] RSP: 0018:ffff881fef893cc8  EFLAGS: 00010246
  [7932653.071374] RAX: 0000000000000001 RBX: ffff883fed5a8800 RCX: 00000000000007c4
  [7932653.071432] RDX: 00000000000000ff RSI: ffff881fef893d68 RDI: ffff883fed5a8824
  [7932653.071489] RBP: ffff881fef893d68 R08: 0000000000000000 R09: 0000000000000000
  [7932653.071546] R10: 0000000000000001 R11: 0000000002408840 R12: ffff8822a92aad00
  [7932653.071603] R13: ffff882dfc7b083c R14: ffff883fed5a8800 R15: ffff883fecb5ad00
  [7932653.071659] FS:  0000000000000000(0000) GS:ffff881fffc00000(0000) knlGS:0000000000000000
  [7932653.071718] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [7932653.071753] CR2: 00007f2d363fc730 CR3: 0000000001806000 CR4: 00000000001406f0
  [7932653.071809] Stack:
   0000000800000018
   ffffffffa044d7e5
   ffff881fef893e60
  [7932653.071843]  ffff881274fca7f8
   ffff883fecb5ad9c
   ffff881fe4e26f00
   001c2ecad4ef6dba
  [7932653.071913]  ffff881ff1babfc0
   ffff882dfc7b083c
   ffff883ff10c3000
   000007c400000000
  [7932653.071982]  ffff881ff1babfc0
  [7932653.072051] Call Trace:
  [7932653.072082]  [<ffffffffa044d7e5>] ? jbd2_journal_commit_transaction+0xa65/0x18a0 [jbd2]
  [7932653.072143]  [<ffffffffa04530f2>] ? kjournald2+0xb2/0x240 [jbd2]
  [7932653.072182]  [<ffffffff81088e90>] ? wake_atomic_t_function+0x50/0x50
  [7932653.072220]  [<ffffffffa0453040>] ? commit_timeout+0x10/0x10 [jbd2]
  [7932653.072258]  [<ffffffff8106e17d>] ? kthread+0xbd/0xe0
  [7932653.072294]  [<ffffffff814638cf>] ? ret_from_fork+0x1f/0x40
  [7932653.072330]  [<ffffffff8106e0c0>] ? kthread_worker_fn+0x160/0x160
  ...
  [<ffffffffa0454728>] jbd2_journal_next_log_block+0x68/0x70 [jbd2]
  [7932653.072732] RIP
  [7932653.072793]  RSP <ffff881fef893cc8>
  [7932653.073307] ---[ end trace 3f9eca026a57b5c2 ]---

And a lot of WARN_ON(blk_needs_flush_plug(tsk)) after:

  [7932653.115857] WARNING: CPU: 0 PID: 356 at kernel/exit.c:737 do_exit+0x50/0xad0
  ...
  [7932653.123101] Call Trace:
  [7932653.123188]  [<ffffffff8122fd58>] ? dump_stack+0x46/0x5e
  [7932653.123280]  [<ffffffff8105312e>] ? __warn+0xbe/0xe0
  [7932653.123371]  [<ffffffff810557b0>] ? do_exit+0x50/0xad0
  [7932653.123462]  [<ffffffff81464a37>] ? rewind_stack_do_exit+0x17/0x20
  [7932653.123556]  [<ffffffff8106e0c0>] ? kthread_worker_fn+0x160/0x160
  [7932653.123648] ---[ end trace 3f9eca026a57b5c4 ]---
  [7932653.123737] Fixing recursive fault but reboot is needed!
  [7932653.123830] BUG: unable to handle kernel

I looked through the code on and on, mailing-lists ([1] and [2]), fixed bugs
(seems that [3] cannot make this), but couldn't find anything that can be
relevant.

And there is a comment in jbd2_journal_commit_transaction():
  /*
   * start_this_handle() uses t_outstanding_credits to determine
   * the free space in the log, but this counter is changed
   * by jbd2_journal_next_log_block() also.
   */
  atomic_dec(&commit_transaction->t_outstanding_credits);

And it is there over decades (since "fs/jbd"), but nothing in
jbd2_journal_next_log_block() touches commit_transaction, maybe it is about
"j_free" (since jbd2_log_space_left() uses t_outstanding_credits and j_free).

[1]: https://lkml.org/lkml/2005/1/19/144
[2]: https://lkml.org/lkml/2008/1/11/235
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=559cce698eaf4ccecb2213b2519ea3a0413e5155

Right now I don't have any reasons to think that this is the hardware
problem, but it is SAMSUNG MZ7KM960HAHP-0Z005 (SSD).

Also this is not reproducible, I got it once (a few days ago, and it works well
before for a year or so), and since than I tried to reproduce it without any
luck (with kvm and without).

It will be great if you can give me some hints in debugging this.

Thanks,
  Azat.
