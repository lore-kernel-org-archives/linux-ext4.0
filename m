From: <Martin_Zielinski@McAfee.com>
Subject: RE: [PATCH 2/2] jbd: fix fsync() tid wraparound bug
Date: Thu, 5 May 2011 09:55:22 -0500
Message-ID: <BCB84D936723884B91E4CC5CA0A7C54AA4F95AA27F@EMEADALEXMB1.corp.nai.org>
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
Received: from dalsmrelay2.nai.com ([205.227.136.216]:61325 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1EEOzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 10:55:31 -0400
In-Reply-To: <20110504215512.GJ6968@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello once more.
I have one concern against the patch:
If the situation is triggered again and again, the patch would produce lots of output.
Maybe it's better to use WARN_ONCE.

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
