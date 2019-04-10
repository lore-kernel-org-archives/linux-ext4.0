Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57F9C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 16:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2462133D
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 16:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbfDJQPS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 12:15:18 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55544 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729048AbfDJQPS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 12:15:18 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DFDD128C0E
        for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2019 16:15:16 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id DE45128CBB; Wed, 10 Apr 2019 16:15:16 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203247] New: jbd2 gets stuck at jbd2_journal_commit_transaction
 frequently
Date:   Wed, 10 Apr 2019 16:15:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext3
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pankajcabs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-203247-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203247

            Bug ID: 203247
           Summary: jbd2 gets stuck at jbd2_journal_commit_transaction
                    frequently
           Product: File System
           Version: 2.5
    Kernel Version: 4.9.86
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext3
          Assignee: fs_ext3@kernel-bugs.osdl.org
          Reporter: pankajcabs@gmail.com
        Regression: No

Created attachment 282263
  --> https://bugzilla.kernel.org/attachment.cgi?id=282263&action=edit
dmesg file

I am noticing jbd2 getting blocked on commit_transaction causing processes to
go in D state for good amount of time, it comes out of that state
automatically. I am dumping the sysrq-w and sysrq-l 

Apr 10 15:47:23 ex-etp3 kernel:sysrq: SysRq : Show Blocked State
Apr 10 15:47:23 ex-etp3 kernel:  task                        PC stack   pid
father
Apr 10 15:47:23 ex-etp3 kernel:jbd2/sda10-8    D    0  2573      2 0x00000000
Apr 10 15:47:23 ex-etp3 kernel: ffff8818347c97c0 0000000000000000
ffff88101c9d0140 ffff8817ff898080
Apr 10 15:47:23 ex-etp3 kernel: ffff88101fd17e40 ffff8817fec47b38
ffffffff816bcf06 ffff8807ff66b040
Apr 10 15:47:23 ex-etp3 kernel: ffff8817ff898080 7fffffffffffffff
ffffffff81c06930 ffffffff816bdae0
Apr 10 15:47:23 ex-etp3 kernel:Call Trace:
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bcf06>] ? __schedule+0x1b6/0x570
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bdae0>] ? bit_wait+0x50/0x50
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bd2f4>] ? schedule+0x34/0x80
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bfd25>] ?
schedule_timeout+0x165/0x290
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff81264366>] ?
generic_make_request+0x116/0x290
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bdae0>] ? bit_wait+0x50/0x50
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bcce9>] ?
io_schedule_timeout+0x99/0x100
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bdaf2>] ? bit_wait_io+0x12/0x60
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bd725>] ? __wait_on_bit+0x55/0x80
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bdae0>] ? bit_wait+0x50/0x50
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816bd919>] ?
out_of_line_wait_on_bit+0x79/0xa0
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff8109d970>] ?
autoremove_wake_function+0x30/0x30
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff8122301f>] ?
jbd2_journal_commit_transaction+0x198f/0x1b00
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff81085b41>] ?
finish_task_switch+0x81/0x1f0
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff81226150>] ? kjournald2+0xc0/0x260
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff8109d940>] ? wake_up_bit+0x20/0x20
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff81226090>] ? commit_timeout+0x10/0x10
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff81080922>] ? kthread+0xd2/0xf0
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816c5645>] ? __clear_rsb+0x25/0x3d
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff81080850>] ? kthread_park+0x50/0x50
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff81068beb>] ? SyS_exit_group+0xb/0x10
Apr 10 15:47:23 ex-etp3 kernel: [<ffffffff816c0ff4>] ? ret_from_fork+0x44/0x70

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
