From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: Fix fsync(2) detection
Date: Thu, 8 Jun 2017 12:04:04 -0400
Message-ID: <20170608160404.euiprmtcvlo76n3g@thunk.org>
References: <20170607133114.27799-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32838 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751614AbdFHQEH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Jun 2017 12:04:07 -0400
Content-Disposition: inline
In-Reply-To: <20170607133114.27799-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 07, 2017 at 03:31:14PM +0200, Jan Kara wrote:
> For some reason lib/config.h.in was missing a definition of HAVE_FSYNC
> and as a result lib/config.h never had HAVE_FSYNC defined. As a result
> we never called fsync(2) for example from
> lib/ext2fs/unix_io.c:unix_flush() when we finished creating filesystem
> and could miss IO errors happening during creating of the filesystem.
> Test generic/405 exposes this problem.
> 
> Fix the problem by defining HAVE_FSYNC in lib/config.h.in.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks for tracking down this regression.  This bug was introduced by
my cherry-picking in changes from the Android AOSP version of
e2fsprogs a few weeks ago.  I was wondering why generic/405 had
regressed.

Thanks, applied.

					- Ted
