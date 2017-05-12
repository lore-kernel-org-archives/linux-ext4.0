From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195729] New: JBD2: Spotted dirty metadata buffer (dev = sda1,
 blocknr = 1766784).There's a risk of filesystem corruption in case of system
 crash.
Date: Fri, 12 May 2017 13:31:46 +0000
Message-ID: <bug-195729-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54548 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751323AbdELNbs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 09:31:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7B9ED28822
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2017 13:31:47 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195729

            Bug ID: 195729
           Summary: JBD2: Spotted dirty metadata buffer (dev = sda1,
                    blocknr = 1766784).There's a risk of filesystem
                    corruption in case of system crash.
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.27
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jqiaoulk@gmail.com
        Regression: No

Hi:


I recently see the error message below when doing the following mount
option in hard drive, after a while, Kernel reports BUG_ON.

The standard kernel version is 3.10.27. This issue can been seen in
many other customer devices with this kernel version.


There are several things worthwhile to mention beforehand:

1. I don't believe its a hardware related issue since it could be
duplicated in our many devices.

2. I don't think it is a real Filesystem corruption since these box
never reboot or remount during the test.

3. Devices are under heavy memory pressure when this issue occur,

4. It is not straightforward and might involve tremendous work to
switch to the latest kernel version.


Mount Option:

/dev/sda1 on /mnt/ type ext4
(rw,nosuid,relatime,nodelalloc,journal_checksum,nobarrier,data=journal)



"

JBD2: Spotted dirty metadata buffer (dev = sda1, blocknr = 1766784).
There's a risk of filesystem corruption in case of system crash.

...........................................................

kernel BUG at fs/jbd2/commit.c:1059!
[<801b0e10>] (jbd2_journal_commit_transaction+0x1304/0x177c) from
[<801b569c>] (kjournald2+0xa8/0x248)
[<801b569c>] (kjournald2+0xa8/0x248) from [<800414c8>] (kthread+0xa0/0xac)
[<800414c8>] (kthread+0xa0/0xac) from [<8000dc98>] (ret_from_fork+0x14/0x3c)

"

The code is listed below at Line 1059:


jbd2_journal_commit_transaction

{

         .....................................................

J_ASSERT_BH(bh, !buffer_dirty(bh));
/*
* The buffer on BJ_Forget list and not jbddirty means
* it has been freed by this transaction and hence it
* could not have been reallocated until this

}


So, I firstly get the call stack to understand why JBD2 reports
Spotted dirty metadata buffer. The dump stack is listed below:


4,173710,227778211328,-;[<80015cf0>] (unwind_backtrace+0x0/0x118) from
[<80011f98>] (show_stack+0x10/0x14)
4,173711,227778220057,-;[<80011f98>] (show_stack+0x10/0x14) from
[<80013b5c>] (ipi_backtrace+0x70/0xa8)
4,173712,227778228492,-;[<80013b5c>] (ipi_backtrace+0x70/0xa8) from
[<80013cf0>] (arch_trigger_all_cpu_backtrace+0x40/0xe0)
4,173713,227778238689,-;[<80013cf0>]
(arch_trigger_all_cpu_backtrace+0x40/0xe0) from [<801ac99c>]
(warn_dirty_buffer+0x2c/0x38)
4,173714,227778249227,-;[<801ac99c>] (warn_dirty_buffer+0x2c/0x38)
from [<801adcc4>] (__jbd2_journal_file_buffer+0xa8/0x1d0)
4,173715,227778259500,-;[<801adcc4>]
(__jbd2_journal_file_buffer+0xa8/0x1d0) from [<801ae8cc>]
(jbd2_journal_dirty_metadata+0x1ec/0x258)
4,173716,227778270828,-;[<801ae8cc>]
(jbd2_journal_dirty_metadata+0x1ec/0x258) from [<8018f680>]
(__ext4_handle_dirty_metadata+0xe0/0x190)
4,173717,227778282332,-;[<8018f680>]
(__ext4_handle_dirty_metadata+0xe0/0x190) from [<8016949c>]
(write_end_fn+0x50/0x7c)
4,173718,227778292340,-;[<8016949c>] (write_end_fn+0x50/0x7c) from
[<8016a860>] (ext4_walk_page_buffers+0x88/0xa0)
4,173719,227778301741,-;[<8016a860>]
(ext4_walk_page_buffers+0x88/0xa0) from [<8016ee8c>]
(ext4_journalled_write_end+0x160/0x308)
4,173720,227778312462,-;[<8016ee8c>]
(ext4_journalled_write_end+0x160/0x308) from [<800afd44>]
(generic_file_buffered_write+0x154/0x224)
4,173721,227778323775,-;[<800afd44>]
(generic_file_buffered_write+0x154/0x224) from [<800b146c>]
(__generic_file_aio_write+0x350/0x3a0)
4,173722,227778334999,-;[<800b146c>]
(__generic_file_aio_write+0x350/0x3a0) from [<800b1510>]
(generic_file_aio_write+0x54/0xb4)
4,173723,227778345615,-;[<800b1510>]
(generic_file_aio_write+0x54/0xb4) from [<80165478>]
(ext4_file_write+0x348/0x430)
4,173724,227778355453,-;[<80165478>] (ext4_file_write+0x348/0x430)
from [<800ef3ec>] (do_sync_readv_writev+0x74/0x98)
4,173725,227778365115,-;[<800ef3ec>] (do_sync_readv_writev+0x74/0x98)
from [<800f01e8>] (do_readv_writev+0xd4/0x200)
4,173726,227778374690,-;[<800f01e8>] (do_readv_writev+0xd4/0x200) from
[<800f03dc>] (vfs_writev+0x58/0x70)
4,173727,227778383399,-;[<800f03dc>] (vfs_writev+0x58/0x70) from
[<800f0494>] (SyS_writev+0x38/0x68)
4,173728,227778391586,-;[<800f0494>] (SyS_writev+0x38/0x68) from
[<8000dbc0>] (ret_fast_syscall+0x0/0x30)

Based on the comment of the JBD2 code in __jbd2_journal_file_buffer, I
quote "For metadata buffers, we track dirty bit in buffer_jbddirty
instead of buffer_dirty. We should not see a dirty bit set here
because we clear it in do_get_write_access but e.g.
tune2fs can modify the sb and set the dirty bit at any time so we try
to gracefully handle that."
it means jbd2 code shouldn't set this buffer_dirty anyway.

and Another comment in do_get_write_access() in transaction.c, it says
more, i quote " it is journaled, and we don't expect dirty buffers
in that state (the buffers should be marked JBD_Dirty instead.)  So
either the IO is being done under our own control and this is a bug,
or it's a third party IO such as dump(8) (which may leave the buffer
scheduled for read --- ie. locked but not dirty) or tune2fs (which may
actually havethe buffer dirtied, ugh.)
"

In our case, the dirty bit of buffer_head is changed between
ext4_write_begin() and ext4_journalled_write_end() as bleow:

"
ext4_write_begin() --> BH dirty bit is 0

ext4_journalled_write_end() --> BH dirty bit is changed to 1 !!! and
error is reported
"

Then I do an experiment change as below in ext4_journalled_write_end()
to see whether the original issue could be duplicated.
After almost a week test, the issue doesn't appear. Therefore, it
seems there are some race conditions that change the value
of BH dirty between ext4_write_begin() and
ext4_journalled_write_end(). (Note: do_journal_get_write_access has
already been
called at ext4_write_begin )

+               ret = ext4_walk_page_buffers(handle, page_buffers(page), from,
+                                            to,
&partial,do_journal_get_write_access);
+
                ret = ext4_walk_page_buffers(handle, page_buffers(page), from,
                                             to, &partial, write_end_fn);



After reviewing the code, it looks although
do_journal_get_write_access() imposes lock on buffer header, it
doesn't lock the whole routine between ext4_write_begin() and
ext4_journalled_write_end(). so i think the buffer head should be
locked at the time until ext4_journalled_write_end() is finished.
Initially, I imagine that I can do the following change but then I
realise a existing buffer lock has already been placed in
jbd2_journal_get_write_access, so making a big buffer lock will
quickly become a performance issue and
also involves a lot of changes.

+ lock all the buffer headers belonging to this page

ext4_write_begin()
.....................................................
 ext4_journalled_write_end()

+ unlock all the buffer headers belonging to this page

Therefore, I propose the following change for simplicity and performance:

--- /linux-3.10.27_old/fs/ext4/inode.c 2014-01-15 23:29:14.000000000 +0000
+++/linux-3.10.27_new/fs/ext4/inode.c 2017-05-11 22:47:58.986146486 +0100
@@ -1084,10 +1084,18 @@
  int ret;
  if (!buffer_mapped(bh) || buffer_freed(bh))
  return 0;
+
+ lock_buffer();
+ if (buffer_dirty(bh)) {
+     clear_buffer_dirty(bh);
+ }
+
  set_buffer_uptodate(bh);
  ret = ext4_handle_dirty_metadata(handle, NULL, bh);
  clear_buffer_meta(bh);
  clear_buffer_prio(bh);
+
+ unlock_buffer();
  return ret;
 }

Thanks
Jmqiao

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
