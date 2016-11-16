From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid lockdep warning when inheriting encryption
 context
Date: Wed, 16 Nov 2016 10:47:38 -0500
Message-ID: <20161116154738.bje52n5gwyve352p@thunk.org>
References: <1479157416-144246-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Jan Kara <jack@suse.cz>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45832 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751520AbcKPPrp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Nov 2016 10:47:45 -0500
Content-Disposition: inline
In-Reply-To: <1479157416-144246-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 14, 2016 at 01:03:36PM -0800, Eric Biggers wrote:
> If the task actually were to wait for the journal to commit in this
> case, then it would deadlock because a handle remains open from
> __ext4_new_inode(), so the running transaction can't be committed yet.
> Fortunately, __jbd2_journal_force_commit() avoids the deadlock by not
> allowing the running transaction to be committed while the current task
> has it open.  However, the above lockdep warning is still triggered.

So this is a false positive introduced by

   1eaa566d368b: jbd2: track more dependencies on transaction commit

Instead of working around the problem here, perhaps it would be better
to fix __jbd2_journal_force_commit() so that it calls a newly created
__jbd2_log_wait_commit() which skips the jbd2_might_wait_for_commit()
(and then have jbd2_log_wait_commit call __jbd2_log_wait_commit with
the might_wait_for_commit check)?

This isn't the only place where jbd2_journal_force_commit() is called
so if the problem is with the lockdep check, maybe we should just fix
the logic in the jbd2 layer, hmm?

					- Ted
