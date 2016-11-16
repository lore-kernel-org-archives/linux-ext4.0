From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: avoid lockdep warning when inheriting encryption
 context
Date: Wed, 16 Nov 2016 09:41:10 -0800
Message-ID: <20161116174110.GA133641@google.com>
References: <1479157416-144246-1-git-send-email-ebiggers@google.com>
 <20161116154738.bje52n5gwyve352p@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:32800 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbcKPRlO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2016 12:41:14 -0500
Received: by mail-pg0-f45.google.com with SMTP id 3so81417404pgd.0
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2016 09:41:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161116154738.bje52n5gwyve352p@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2016 at 10:47:38AM -0500, Theodore Ts'o wrote:
> 
> So this is a false positive introduced by
> 
>    1eaa566d368b: jbd2: track more dependencies on transaction commit
> 
> Instead of working around the problem here, perhaps it would be better
> to fix __jbd2_journal_force_commit() so that it calls a newly created
> __jbd2_log_wait_commit() which skips the jbd2_might_wait_for_commit()
> (and then have jbd2_log_wait_commit call __jbd2_log_wait_commit with
> the might_wait_for_commit check)?
> 
> This isn't the only place where jbd2_journal_force_commit() is called
> so if the problem is with the lockdep check, maybe we should just fix
> the logic in the jbd2 layer, hmm?
> 
> 					- Ted

The lockdep warning still seems helpful because it will show places that try to
force-commit the journal while holding an open handle.  Callers probably won't
expect that this will be a no-op, and it may indicate that the attempt to
force-commit the journal is in the wrong place, as it was here.

You and Jan know more about this than I do, though; I could be wrong.

Eric
