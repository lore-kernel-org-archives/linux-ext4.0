From: <Martin_Zielinski@McAfee.com>
Subject: RE: [PATCH 2/2] jbd: fix fsync() tid wraparound bug
Date: Thu, 5 May 2011 09:11:22 -0500
Message-ID: <BCB84D936723884B91E4CC5CA0A7C54AA4F95AA264@EMEADALEXMB1.corp.nai.org>
References: <20110425231454.GB9486@thunk.org>
 <1303777411-1316-2-git-send-email-tytso@mit.edu>
 <20110430171711.GA2819@thunk.org> <20110502150758.GH4556@quack.suse.cz>
 <20110502182945.GG2819@thunk.org> <20110502190441.GK4556@quack.suse.cz>
 <20110502213113.GI2819@thunk.org>
 <BCB84D936723884B91E4CC5CA0A7C54AA4F95A9F32@EMEADALEXMB1.corp.nai.org>
 <20110504215512.GJ6968@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
To: <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dalsmrelay2.nai.com ([205.227.136.216]:25540 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1EEOMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 10:12:00 -0400
In-Reply-To: <20110504215512.GJ6968@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is not a hardware bug and very unlikely a race condition or random memory corruption.
We have 7 machines that failed with an uptime of 12-13 days.
12 days earlier about 5 different machines failed after the same uptime. All machines were rebooted
after this issue.

In 5 out of 7 cores the commit request number come from the same sqlite database.
In 2 cores I could not find an inode or file structure pointing to this database and hence
it could not be verified that the request number comes from this database inode.

I'm not so sure about the bit error. Some have the hi-bit set, some not.
Due to the implementation of tid_gt() I would  expect that the numbers differ in the high bit.
The condition produces a wrong result, if the difference between the numbers is greater than INT_MAX.

The sequence / request numbers / difference INT_MAX + x:
886052f3 / 086052f1 / 3
61d305fe / e1ce83f4 / 295434
887d10c8 / 087acf05 / 147908
8e3d0b25 / 0e374365 / 378817
702d4061 / f02a5e0b / 189014
73d6775a / f3d67756 / 4
824846ad / 024846ab / 2

On some of the machines we traced the commit_sequence for a short time.
However no indication could be found the logs, that a datasync was triggered with always the same tid.

Result example:

Uptime 5 days, 33 min : commit_sequence: 1135688364
Uptime 12 days,  2:40 : commit_sequence: 1960701710

825013346 commits in 170 hours

4853019 commits per hour => 442 hours or 18 days to have INT_MAX commits.

Cheers,
Martin

-----Original Message-----
From: Jan Kara [mailto:jack@suse.cz]
Sent: Mittwoch, 4. Mai 2011 23:55
To: Zielinski, Martin
Cc: tytso@mit.edu; jack@suse.cz; linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] jbd: fix fsync() tid wraparound bug

On Wed 04-05-11 09:21:04, Martin_Zielinski@McAfee.com wrote:
> Here's an update.
> In my first post I was not aware of the implementation of tid_gt.
> I agree that 2 and a half billion commits on an SD card are - hmph -
> unlikely
  <snip>

> gdb) p *journal
> $4 = {j_flags = 16, j_errno = 0, j_sb_buffer = 0xffff88031f156dc8,
>   j_superblock = 0xffff88031f876000, j_format_version = 2, j_state_lock = {raw_lock = {
>       slock = 2874125135}}, j_barrier_count = 0, j_barrier = {count = {counter = 1}, wait_lock = {
>       raw_lock = {slock = 0}}, wait_list = {next = 0xffff88031e6c4638,
>       prev = 0xffff88031e6c4638}, owner = 0x0}, j_running_transaction = 0x0,
>   j_committing_transaction = 0x0, j_checkpoint_transactions = 0xffff88031bd16b40,
> ...
> j_tail_sequence = 2288011385, j_transaction_sequence = 2288014068,
>   j_commit_sequence = 2288014067, j_commit_request = 140530417,
> ...
>   j_wbuf = 0xffff88031de98000, j_wbufsize = 512, j_last_sync_writer = 4568,
>   j_average_commit_time = 69247, j_private = 0xffff88031fd49400}
  <snip>

> (gdb) p ((struct ext3_inode_info*)(0xffff88031f0c0758-0xd0))->i_sync_tid
> $5 = {counter = -2006954411}
> (gdb) p ((struct ext3_inode_info*)(0xffff88031f0c0758-0xd0))->i_datasync_tid
> $3 = {counter = 140530417}
>
> > j_commit_request = 140530417
>
> So it *is* a datasync from sqlite. And your fix will catch it.
> I still don't understand, where this number comes from.
  Ok, so i_datasync_tid got corrupted. But look at the numbers in hex:
i_datasync_tid==140530417==0x86052F1
and
i_commit_sequence==2288014067==0x886052F3

So it's a single bit error - we lost the highest bit of the number. Are you
getting the cores from different machines? Otherwise I'd suspect the HW.
If it's not HW I'm at loss what can cause it... You can try moving
i_datasync_tid to a different place in struct ext3_inode_info so that we
can rule out / confirm whether some code external to i_datasync_tid
handling is just causing random memory corruption...

                                                                Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
