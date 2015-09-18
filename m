From: Dmitry Vyukov <dvyukov@google.com>
Subject: Help to explain a data race in ext4_da_invalidatepage
Date: Fri, 18 Sep 2015 14:25:35 +0200
Message-ID: <CACT4Y+Zsj043RxDbjCMzOzjGqZm57BYRPm7xZJ63X65hXAsWLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrey Konovalov <andreyknvl@google.com>, ktsan@googlegroups.com
To: Theodore Tso <tytso@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37610 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbbIRMZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2015 08:25:56 -0400
Received: by wicfx3 with SMTP id fx3so28816095wic.0
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2015 05:25:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

We are working on a data race detector for kernel,
KernelThreadSanitizer (https://github.com/google/ktsan) and got the
following race report (on 4.2. rc2). My ext4-fu is not strong enough
to prove or disprove whether it is a real issue or a bug in the tool.

I will appreciate if you explain how the following memory accesses are
supposed to be synchronized (not happen concurrently).

I've got a bunch of similar reports in different kernel runs, the
first stack always starts at ftruncate (or compat_ftruncate), the
second always includes __writeback_inodes_wb (all reports essentially
look like this one). Also, the first stack always contains
ext4_da_invalidatepage and not other callbacks, so maybe it is
something with delalloc (pure speculation).


ThreadSanitizer: data-race in kmem_cache_free

Write at 0xffff8800bb412e70 of size 8 by thread 3050 on CPU 9:
 [<     inline     >] __cache_free mm/slab.c:3384
 [<ffffffff812451f2>] kmem_cache_free+0x92/0x480 mm/slab.c:3562
 [<ffffffff812b7800>] free_buffer_head+0x40/0x70 fs/buffer.c:3363
 [<ffffffff812b922d>] try_to_free_buffers+0xcd/0x120 fs/buffer.c:3278
(discriminator 1)
 [<ffffffff813b7da9>] jbd2_journal_try_to_free_buffers+0x109/0x190
fs/jbd2/transaction.c:1960
 [<ffffffff8133666f>] ext4_releasepage+0x9f/0x120 fs/ext4/inode.c:2995
 [<ffffffff811cbf3b>] try_to_release_page+0x6b/0x90 mm/filemap.c:2688
 [<ffffffff812b885e>] block_invalidatepage+0x16e/0x1c0 fs/buffer.c:1576
 [<ffffffff813375e1>] ext4_invalidatepage+0x81/0x100
fs/ext4/inode.c:2957 (discriminator 11)
 [<ffffffff81338a70>] ext4_da_invalidatepage+0x50/0x540 fs/ext4/inode.c=
:2802
 [<     inline     >] do_invalidatepage mm/truncate.c:92
 [<     inline     >] truncate_complete_page mm/truncate.c:112
 [<ffffffff811e4dae>] truncate_inode_page+0xde/0xe0 mm/truncate.c:156
 [<ffffffff811e503b>] truncate_inode_pages_range+0x20b/0x8e0 mm/truncat=
e.c:280
 [<     inline     >] truncate_inode_pages mm/truncate.c:390
 [<ffffffff811e585c>] truncate_pagecache+0x5c/0x80 mm/truncate.c:685
 [<ffffffff81344032>] ext4_setattr+0x682/0xcd0 fs/ext4/inode.c:4768
 [<ffffffff8129034d>] notify_change+0x3ed/0x570 fs/attr.c:266
 [<ffffffff8125d0a2>] do_truncate+0xb2/0x110 fs/open.c:63
 [<ffffffff8125d592>] do_sys_ftruncate.constprop.16+0x182/0x1f0 fs/open=
=2Ec:193
 [<     inline     >] C_SYSC_ftruncate fs/open.c:209
 [<ffffffff8125d6d0>] compat_SyS_ftruncate+0x20/0x30 fs/open.c:207
 [<ffffffff81ee681a>] ia32_do_call+0x1b/0x25
arch/x86/entry/entry_64_compat.S:505

Previous read at 0xffff8800bb412e70 of size 8 by thread 829 on CPU 0:
 [<ffffffff813379f2>] mpage_process_page_bufs+0x202/0x220 fs/ext4/inode=
=2Ec:1973
 [<ffffffff81338520>] mpage_prepare_extent_to_map+0x450/0x500
fs/ext4/inode.c:2351 (discriminator 2)
 [<ffffffff8133ffaa>] ext4_writepages+0x64a/0x15e0 fs/ext4/inode.c:2505
 [<ffffffff811e0453>] do_writepages+0x53/0x80 mm/page-writeback.c:2332
 [<ffffffff812aac2f>] __writeback_single_inode+0x7f/0x510
fs/fs-writeback.c:1259 (discriminator 3)
 [<ffffffff812ab5b8>] writeback_sb_inodes+0x4f8/0x720 fs/fs-writeback.c=
:1516
 [<ffffffff812ab8a4>] __writeback_inodes_wb+0xc4/0x100 fs/fs-writeback.=
c:1562
 [<ffffffff812abc8c>] wb_writeback+0x3ac/0x440 fs/fs-writeback.c:1666
 [<     inline     >] wb_check_background_flush fs/fs-writeback.c:1746
 [<     inline     >] wb_do_writeback fs/fs-writeback.c:1824
 [<ffffffff812ac9df>] wb_workfn+0x43f/0x7e0 fs/fs-writeback.c:1852
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529

Mutexes locked by thread 3050:
Mutex 469545 is locked here:
 [<ffffffff81ee0407>] mutex_lock+0x57/0x70 kernel/locking/mutex.c:108
 [<ffffffff8125d094>] do_truncate+0xa4/0x110 fs/open.c:61
 [<ffffffff8125d592>] do_sys_ftruncate.constprop.16+0x182/0x1f0 fs/open=
=2Ec:193
 [<     inline     >] C_SYSC_ftruncate fs/open.c:209
 [<ffffffff8125d6d0>] compat_SyS_ftruncate+0x20/0x30 fs/open.c:207
 [<ffffffff81ee681a>] ia32_do_call+0x1b/0x25
arch/x86/entry/entry_64_compat.S:505

Mutexes locked by thread 829:
Mutex 119525 is read locked here:
 [<ffffffff810de882>] down_read_trylock+0x52/0x60 kernel/locking/rwsem.=
c:45
 [<ffffffff81265428>] trylock_super+0x28/0x90 fs/super.c:369
 [<ffffffff812ab85d>] __writeback_inodes_wb+0x7d/0x100 fs/fs-writeback.=
c:1553
 [<ffffffff812abc8c>] wb_writeback+0x3ac/0x440 fs/fs-writeback.c:1666
 [<     inline     >] wb_check_background_flush fs/fs-writeback.c:1746
 [<     inline     >] wb_do_writeback fs/fs-writeback.c:1824
 [<ffffffff812ac9df>] wb_workfn+0x43f/0x7e0 fs/fs-writeback.c:1852
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529


The second memory access is read of head->b_page, while head is being f=
reed.
This followed by some other accesses to buffer_head, for example (this
is read of bh_offset(bh)):

Previous read at 0xffff8800bb412e88 of size 8 by thread 829 on CPU 0:
 [<ffffffff81345e2a>] ext4_bio_write_page+0xfa/0x5e0 fs/ext4/page-io.c:=
460
 [<ffffffff81337786>] mpage_submit_page+0x96/0x100 fs/ext4/inode.c:1868
 [<ffffffff813379fe>] mpage_process_page_bufs+0x20e/0x220 fs/ext4/inode=
=2Ec:1973
 [<ffffffff81338520>] mpage_prepare_extent_to_map+0x450/0x500
fs/ext4/inode.c:2351 (discriminator 2)
 [<ffffffff8133ffaa>] ext4_writepages+0x64a/0x15e0 fs/ext4/inode.c:2505
 [<ffffffff811e0453>] do_writepages+0x53/0x80 mm/page-writeback.c:2332
 [<ffffffff812aac2f>] __writeback_single_inode+0x7f/0x510
fs/fs-writeback.c:1259 (discriminator 3)
 [<ffffffff812ab5b8>] writeback_sb_inodes+0x4f8/0x720 fs/fs-writeback.c=
:1516
 [<ffffffff812ab8a4>] __writeback_inodes_wb+0xc4/0x100 fs/fs-writeback.=
c:1562
 [<ffffffff812abc8c>] wb_writeback+0x3ac/0x440 fs/fs-writeback.c:1666
 [<     inline     >] wb_check_background_flush fs/fs-writeback.c:1746
 [<     inline     >] wb_do_writeback fs/fs-writeback.c:1824
 [<ffffffff812ac9df>] wb_workfn+0x43f/0x7e0 fs/fs-writeback.c:1852
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529


Thanks in advance



--=20
Dmitry Vyukov, Software Engineer, dvyukov@google.com
Google Germany GmbH, Dienerstra=C3=9Fe 12, 80331, M=C3=BCnchen
Gesch=C3=A4ftsf=C3=BChrer: Graham Law, Christine Elizabeth Flores
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
Diese E-Mail ist vertraulich. Wenn Sie nicht der richtige Adressat
sind, leiten Sie diese bitte nicht weiter, informieren Sie den
Absender und l=C3=B6schen Sie die E-Mail und alle Anh=C3=A4nge. Vielen =
Dank.
This e-mail is confidential. If you are not the right addressee please
do not forward it, please inform the sender, and please erase this
e-mail including any attachments. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
