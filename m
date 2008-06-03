From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Tue, 3 Jun 2008 10:02:19 +0200
Message-ID: <20080603080219.GA17936@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com> <20080602124409.GL30613@duck.suse.cz> <4844CB39.6060409@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53752 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752624AbYFCICU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jun 2008 04:02:20 -0400
Content-Disposition: inline
In-Reply-To: <4844CB39.6060409@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 03-06-08 13:40:25, Hidehiro Kawai wrote:
> Subject: [PATCH 4/5] jbd: fix error handling for checkpoint io
> 
> When a checkpointing IO fails, current JBD code doesn't check the
> error and continue journaling.  This means latest metadata can be
> lost from both the journal and filesystem.
> 
> This patch leaves the failed metadata blocks in the journal space
> and aborts journaling in the case of log_do_checkpoint().
> To achieve this, we need to do:
> 
> 1. don't remove the failed buffer from the checkpoint list where in
>    the case of __try_to_free_cp_buf() because it may be released or
>    overwritten by a later transaction
> 2. log_do_checkpoint() is the last chance, remove the failed buffer
>    from the checkpoint list and abort the journal
> 3. when checkpointing fails, don't update the journal super block to
>    prevent the journaled contents from being cleaned.  For safety,
>    don't update j_tail and j_tail_sequence either
> 4. when checkpointing fails, notify this error to the ext3 layer so
>    that ext3 don't clear the needs_recovery flag, otherwise the
>    journaled contents are ignored and cleaned in the recovery phase
> 5. if the recovery fails, keep the needs_recovery flag
> 6. prevent cleanup_journal_tail() from being called between
>    __journal_drop_transaction() and journal_abort() (a race issue
>    between journal_flush() and __log_wait_for_space()
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
  You can add:
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
