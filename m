From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 4/4] jbd: fix error handling for checkpoint io (rebased)
Date: Mon, 26 May 2008 13:57:23 +0900
Message-ID: <483A4333.301@hitachi.com>
References: <482A6E00.6080303@hitachi.com> <482A6FA3.9000104@hitachi.com>
    <20080514143217.GF24363@duck.suse.cz> <482D61FB.7050706@hitachi.com>
    <20080519033805.GD10233@duck.suse.cz> <48337C21.1010808@hitachi.com>
    <20080523222835.GA30591@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45700 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYEZE5d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 00:57:33 -0400
In-Reply-To: <20080523222835.GA30591@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

>>Jan Kara wrote:
>>
>>>On Fri 16-05-08 19:29:15, Hidehiro Kawai wrote:
>>>
>>>
>>>>Jan Kara wrote:
>>>>
>>>>
>>>>>>/*
>>>>>>+ * We couldn't write back some metadata buffers to the filesystem.
>>>>>>+ * To avoid unwritten-back metadata buffers from losing, set
>>>>>>+ * JFS_CP_ABORT flag and make sure that the journal space isn't
>>>>>>+ * cleaned.  This function also aborts journaling.
>>>>>>+ */
>>>>>>+static void __journal_abort_checkpoint(journal_t *journal, int errno)
>>>>>>+{
>>>>>>+	if (is_checkpoint_aborted(journal))
>>>>>>+		return;
>>>>>>+
>>>>>>+	spin_lock(&journal->j_state_lock);
>>>>>>+	journal->j_flags |= JFS_CP_ABORT;
>>>>>>+	spin_unlock(&journal->j_state_lock);
>>>>>>+	printk(KERN_WARNING "JBD: Checkpointing failed.  Some metadata blocks "
>>>>>>+	       "are still old.\n");
>>>>>>+	journal_abort(journal, errno);
>>>>>>+}
>>>>
>>>>[snip]
>>>>
>>>>
>>>>
>>>>>>Index: linux-2.6.26-rc2/include/linux/jbd.h
>>>>>>===================================================================
>>>>>>--- linux-2.6.26-rc2.orig/include/linux/jbd.h
>>>>>>+++ linux-2.6.26-rc2/include/linux/jbd.h
>>>>>>@@ -816,6 +816,8 @@ struct journal_s
>>>>>>#define JFS_FLUSHED	0x008	/* The journal superblock has been flushed */
>>>>>>#define JFS_LOADED	0x010	/* The journal superblock has been loaded */
>>>>>>#define JFS_BARRIER	0x020	/* Use IDE barriers */
>>>>>>+#define JFS_CP_ABORT	0x040	/* Checkpointing has failed.  We don't have to
>>>>>>+				 * clean the journal space.  */
>>>>>>
>>>>>>/*
>>>>>>* Function declarations for the journaling transaction and buffer
>>>>>>@@ -1004,6 +1006,11 @@ static inline int is_journal_aborted(jou
>>>>>>	return journal->j_flags & JFS_ABORT;
>>>>>>}
>>>>>>
>>>>>>+static inline int is_checkpoint_aborted(journal_t *journal)
>>>>>>+{
>>>>>>+	return journal->j_flags & JFS_CP_ABORT;
>>>>>>+}
>>>>>>+
>>>>>
>>>>> Actually, I don't think this new flag is needed (not that it would really
>>>>>harm anything). At least at the places where you check it you can as well
>>>>>check whether the journal is aborted (maybe except for journal_destroy()
>>>>>but see my comment there).
>>>>
>>>>As you say, JFS_CP_ABORT isn't necessarily needed in the most cases,
>>>>but it is needed for __journal_abort_checkpoint() which report the
>>>>checkpoint related error by printk only once.  If we use JFS_ABORT
>>>>to check whether this call is second time, the error message may be
>>>>never printed out because the journal has been aborted by another
>>>>reason.  If we don't check for the second call, the error message
>>>>will be printed out several times.
>>>
>>>  Yes, I think that checking out for JFS_ABORT is the right thing to do.
>>>Once the journal has aborted for some reason, it is enough that we print
>>>some error message (and that is responsibility of the first caller of
>>>journal_abort()). Printing that checkpointing has not succeeded as well is
>>>IMO not needed.
>>
>>A checkpointing failure is a bit special.  If the journal is aborted
>>by journal_commit_transaction(), the integrity of the filesystem is
>>ensured although the latest changes will be lost.  However, if the
>>journal is aborted by log_do_checkpoint() and the replay also failed,
>>the filesystem may be corrupted because some of the metadata blocks
>>are in old states.  In this case, the user will have to recover the
>>filesystem manually and carefully.  So I think printing the special
>>message is needed to inform users about that.
> 
>   Is this really different? If we spot error during checkpointing, we
> abort journal (so data still remain in the journal because checkpointing
> has failed). On next mount, either replay succeeds and everything is fine,
> or we spot error during replay and we should just refuse to mount the
> filesystem. So we are correct again - user then has to run fsck to solve
> the problem and that will try it's best to get most data readable. So I
> don't see why checkpointing bug would need a special attention.

I understand.

I have thought the following scenario.  When we failed to checkpoint
and replay, copy all readable blocks from the bad disk to a good disk,
and we can replay all journaled data on the good disk.  But it will be
overkill.  Normally we run the fsck when we failed to mount, and it's
enough for us.

I'm going to just use JFS_ABORT instead of introducing JFS_CP_ABORT
in the next revision.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

