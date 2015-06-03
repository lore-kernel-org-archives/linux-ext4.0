From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [Ocfs2-devel] ocfs2 inconsistent when updating journal superblock
 failed
Date: Wed, 03 Jun 2015 10:40:03 +0800
Message-ID: <556E6903.9090800@oracle.com>
References: <556D5FAC.20702@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@huawei.com>,
	"ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43201 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbbFCCmz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jun 2015 22:42:55 -0400
In-Reply-To: <556D5FAC.20702@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Joseph,

On 06/02/2015 03:47 PM, Joseph Qi wrote:
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
If this is the case, this seemed a generic issue. Assume a two node
cluster, node 1 updated global bitmap, and the transaction for this
update have been written into node 1's journal. Then node 2 updated
global bitmap, after that, node 1 crash and node 2 replay node 1's
journal and will overwrite global bitmap to old one. Do i miss some point?

Thanks,
Junxiao.

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

