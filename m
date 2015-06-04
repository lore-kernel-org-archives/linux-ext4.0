From: Joseph Qi <joseph.qi@huawei.com>
Subject: Re: [Ocfs2-devel] ocfs2 inconsistent when updating journal superblock
 failed
Date: Thu, 4 Jun 2015 19:26:52 +0800
Message-ID: <557035FC.6040608@huawei.com>
References: <556D5FAC.20702@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
	<linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:48472 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbbFDLed (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2015 07:34:33 -0400
In-Reply-To: <556D5FAC.20702@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
I have gone through the latest jbd2 code, though some functions are
refactored, the error is still omitted when updating superblock fails.
I want to return the error to the caller, so that ocfs2_commit_cache
fails without incrementing trans id and then prevents the other node
doing update. Only after it has recovered the failed node, it can
proceeds to do update.
But this may impact some flows in jbd2. Could you please give your
valuable inputs to fix this issue?

On 2015/6/2 15:47, Joseph Qi wrote:
> Hi all,
> If jbd2 has failed to update superblock because of iscsi link down, it
> may cause ocfs2 inconsistent.
> 
> kernel version: 3.0.93
> dmesg:
> JBD2: I/O error detected when updating journal superblock for
> dm-41-36.
> 
> Case description:
> Node 1 was doing the checkpoint of global bitmap.
> ocfs2_commit_thread
>   ocfs2_commit_cache
>     jbd2_journal_flush
>       jbd2_cleanup_journal_tail
>         jbd2_journal_update_superblock
>           sync_dirty_buffer
>             submit_bh  *failed*
> Since the error was ignored, jbd2_journal_flush would return 0.
> Then ocfs2_commit_cache thought it normal, incremented trans id and woke
> downconvert thread.
> So node 2 could get the lock because the checkpoint had been done
> successfully (in fact, bitmap on disk had been updated but journal
> superblock not). Then node 2 did the update to global bitmap as normal.
> After a while, node 2 found node 1 down and began the journal recovery.
> As a result, the new update by node 2 would be overwritten and filesystem
> became inconsistent.
> 
> I'm not sure if ext4 has the same case (can it be deployed on LUN?).
> But for ocfs2, I don't think the error can be omitted.
> Any ideas about this?
> 
> Thanks,
> Joseph
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 


