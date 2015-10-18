From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix checkpoint list cleanup
Date: Sat, 17 Oct 2015 22:42:52 -0400
Message-ID: <20151018024252.GJ2678@thunk.org>
References: <1444053572-15671-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56701 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbbJRCm4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2015 22:42:56 -0400
Content-Disposition: inline
In-Reply-To: <1444053572-15671-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 05, 2015 at 03:59:32PM +0200, Jan Kara wrote:
> Unlike comments and expectation of callers journal_clean_one_cp_list()
> returned 1 not only if it freed the transaction but also if it freed
> some buffers in the transaction. That could make
> __jbd2_journal_clean_checkpoint_list() skip processing
> t_checkpoint_io_list and continue with processing the next transaction.
> This is mostly a cosmetic issue since the only result is we can
> sometimes free less memory than we could. But it's still worth fixing.
> Fix journal_clean_one_cp_list() to return 1 only if the transaction was
> really freed.
> 
> Fixes: 50849db32a9f529235a84bcc84a6b8e631b1d0ec
> Signed-off-by: Jan Kara <jack@suse.com>

Applied, thanks.

					- Ted
