From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 3/5] jbd: abort when failed to log metadata buffers
Date: Wed, 04 Jun 2008 19:57:50 +0900
Message-ID: <4846752E.9080501@hitachi.com>
References: <4843CE15.6080506@hitachi.com> <4843CF6A.7090107@hitachi.com>
    <20080603153506.8a9ca2a4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50194 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYFDK57 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 06:57:59 -0400
In-Reply-To: <20080603153506.8a9ca2a4.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Andrew Morton wrote:

> On Mon, 02 Jun 2008 19:46:02 +0900
> Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
> 
>>Subject: [PATCH 3/5] jbd: abort when failed to log metadata buffers
>>
>>If we failed to write metadata buffers to the journal space and
>>succeeded to write the commit record, stale data can be written
>>back to the filesystem as metadata in the recovery phase.
>>
>>To avoid this, when we failed to write out metadata buffers,
>>abort the journal before writing the commit record.
>>
>>Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>>---
>> fs/jbd/commit.c |    3 +++
>> 1 file changed, 3 insertions(+)
>>
>>Index: linux-2.6.26-rc4/fs/jbd/commit.c
>>===================================================================
>>--- linux-2.6.26-rc4.orig/fs/jbd/commit.c
>>+++ linux-2.6.26-rc4/fs/jbd/commit.c
>>@@ -734,6 +734,9 @@ wait_for_iobuf:
>> 		/* AKPM: bforget here */
>> 	}
>> 
>>+	if (err)
>>+		journal_abort(journal, err);
>>+
>> 	jbd_debug(3, "JBD: commit phase 6\n");
>> 
>> 	if (journal_write_commit_record(journal, commit_transaction))
>>
> 
> 
> I assume this has all been tested?

Yes,  I tested all cases except for the following case (related to
PATCH 4/5):

> o journal_flush() uses j_checkpoint_mutex to avoid a race with
>  __log_wait_for_space()
> 
> The last item targets a newly found problem.  journal_flush() can be
> called while processing __log_wait_for_space().  In this case,
> cleanup_journal_tail() can be called between
> __journal_drop_transaction() and journal_abort(), then 
> the transaction with checkpointing failure is lost from the journal.
> Using j_checkpoint_mutex which is used by __log_wait_for_space(),
> we should avoid the race condition.  But the test is not so sufficient
> because it is very difficult to produce this race.  So I hope that
> this locking is reviewed carefully (including a possibility of
> deadlock.)

I caused invocations of journal_flush() and __log_wait_for_space() and
a write error simultaneously, but I haven't confirmed the race had
occurred.

> How are you finding these problems and testing the fixes?  Fault
> injection?

I found these problems by reading souce codes, then tested them
by the fault injection approach.  To inject a fault, I used a
SystemTap script at the bottom of this mail.

> Does it make sense to proceed into phase 6 here, or should we bale out
> of commit at this point?

What I really want to do is that don't write the commit record when
metadata buffers couldn't be written to the journal.
It should be no problem in the case of writing revoke records failure
because the recovery process detects the invalid control block with
a noncontiguous sequence number.
But it is nonsense to write the commit record even though we failed
to write control blocks to the journal.  So I think it makes sense
to catch errors for all writes to the journal here and abort the
journal to avoid writing the commit record.

* * * * * *

The following SystemTap script was used to inject a fault.
Please don't use this script without changing.  It is hard-coded
for my environment.


global target_inode_block = 64
/*
 * Inject a fault when a particular metadata buffer is journaled.
 */

%{
#include <linux/buffer_head.h>
#include <linux/jbd.h>
#include <scsi/scsi.h>
#include <scsi/scsi_cmnd.h>

enum fi_state_bits {
	BH_Faulty = BH_Unshadow + 1,
};
%}

function fault_inject (scmd: long) %{
	struct scsi_cmnd *cmd = (void *)((unsigned long)THIS->scmd);
	cmd->cmnd[0] |= (7 << 5);
	cmd->cmd_len = 255;
%}

global do_fault_inject
global faulty_sector
probe module("jbd").function("journal_write_metadata_buffer") {
	if ($jh_in->b_bh->b_blocknr == target_inode_block) {
		do_fault_inject[tid()] = 1
	}
}
probe module("jbd").function("journal_write_metadata_buffer").return {
	do_fault_inject[tid()] = 0
}

probe module("jbd").function("journal_file_buffer") {
	if (do_fault_inject[tid()] && $jlist == 4 /* BJ_IO */) {
		faulty_sector[$jh->b_bh->b_blocknr * 8 + 63] = 1
		printf("mark faulty @ sector=%d\n",
			$jh->b_bh->b_blocknr * 8 + 63)
	}
}

probe kernel.function("scsi_dispatch_cmd") {
	host = $cmd->device->host->host_no
	id = $cmd->device->id
	lun = $cmd->device->lun
	ch = $cmd->device->channel
	sector = $cmd->request->bio->bi_sector
	len = $cmd->transfersize / 512

	if (id != 1) {
		next
	}
	printf("%d:%d:%d:%d, #%d+%d\n", host, ch, id, lun, sector, len)
	if ($cmd->request->cmd_flags & 1 == 1 && faulty_sector[sector]) {
		delete faulty_sector[sector]
		fault_inject($cmd)
		printf("fault injected\n")
	}
}

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

