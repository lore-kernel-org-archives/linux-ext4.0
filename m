From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Thu, 18 Jan 2018 10:33:47 +0000
Message-ID: <bug-198187-13602-uK3IaBSDpw@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48766 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754759AbeARKdr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Jan 2018 05:33:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4C3212684F
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jan 2018 10:33:47 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

--- Comment #9 from lavv17@gmail.com ---
You are correct that we use plain SATA drives. LVM on top of them, with
raid1 mode.

18 янв. 2018 г. 13:06 пользователь <bugzilla-daemon@bugzilla.kernel.org>
написал:

> https://bugzilla.kernel.org/show_bug.cgi?id=198187
>
> --- Comment #8 from Jan Kara (jack@suse.cz) ---
> Thanks for the output. So every process there waits for jbd2 thread to
> commit
> the running transaction. JBD2 does:
>
> [144526.447408] jbd2/dm-19-8    D    0  1580      2 0x00000080
> [144526.448176] Call Trace:
> [144526.448937]  __schedule+0x3be/0x830
> [144526.449632]  ? scsi_request_fn+0x3f/0x6b0
> [144526.450310]  ? bit_wait+0x60/0x60
> [144526.450993]  schedule+0x36/0x80
> [144526.451673]  io_schedule+0x16/0x40
> [144526.452343]  bit_wait_io+0x11/0x60
> [144526.453017]  __wait_on_bit+0x58/0x90
> [144526.453692]  out_of_line_wait_on_bit+0x8e/0xb0
> [144526.454371]  ? bit_waitqueue+0x40/0x40
> [144526.455051]  __wait_on_buffer+0x32/0x40
> [144526.455731]  jbd2_journal_commit_transaction+0xfa4/0x1800
> [144526.456414]  kjournald2+0xd2/0x270
> [144526.457098]  ? kjournald2+0xd2/0x270
> [144526.457782]  ? remove_wait_queue+0x70/0x70
> [144526.458470]  kthread+0x109/0x140
> [144526.459139]  ? commit_timeout+0x10/0x10
> [144526.459821]  ? kthread_park+0x60/0x60
> [144526.460497]  ? do_syscall_64+0x67/0x150
> [144526.461166]  ret_from_fork+0x25/0x30
>
> So we have submitted buffers for IO and they have not completed. In cases
> like
> this the problem is in 99% of cases either in the storage driver or in the
> storage firmware. Since you mentioned this started happening after kernel
> update and you seem to be using only plain SATA drives (am I right?),
> storage
> firmware is probably out of question.
>
> You seem to be using some kind of RAID on top of these SATA drives, that
> would
> look like the most probable culprit at this point. Can you describe your
> storage configuration? Also output of 'dmsetup table' would be useful.
> After
> having that we would probably need to pull in DM developers to have a look.
> Thanks.
>
> --
> You are receiving this mail because:
> You reported the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
