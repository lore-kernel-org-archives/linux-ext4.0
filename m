From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] jbd2: Issue cache flush after checkpointing even
 with internal journal
Date: Wed, 8 Feb 2012 22:05:51 -0500
Message-ID: <20120209030551.GH18461@thunk.org>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
 <1326241872-20142-2-git-send-email-jack@suse.cz>
 <20120111124918.GD26337@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42211 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542Ab2BIDF4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Feb 2012 22:05:56 -0500
Content-Disposition: inline
In-Reply-To: <20120111124918.GD26337@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Am I missing something?  In the original code, we figure out the block
# of the tail of the journal while holding the j_state_lock for
writing, and we hold the lock until journal->j_tail is updated.

In your proposed replacement code, you call
jbd2_journal_get_log_tail() to determine the block #, but you aren't
holding any locks.  jbd2_journal_get_log_tail() grabs a read lock to
figure out the block number, but then drops the lock before it
returns.  So then journal->j_tail gets updated by
jbd2_journal_update_tail() --- using the block # determined by
jbd2_journal_get_log_tail(), but we've released the lock, so can we
guarantee the block number is still accurate?

In particular, since jbd2_cleanup_journal_tail() is now not holding
any locks, what if it is racing against itself?  I can't quite see
race that would lead to something horrible happening, but my spidey
sense is tingling....

Also:

> +/*
> + * Update information in journal about log tail. The function returns 1 if
> + * tail was updated, 0 otherwise. If 1 is returned, caller *must* write
> + * journal superblock before next transaction commit is started.
> + */

If jbd2_update_log_tail() returns 1, how is this enforced?  The caller
can issue a journal superblocok update, sure, but there's no locking
to prevent some other process from immediately starting a new
transaction?

Again, am I missing something?

Regards,

							- Ted
