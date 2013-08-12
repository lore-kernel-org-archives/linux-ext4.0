From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix use after free after error in
 jbd2_journal_dirty_metadata()
Date: Mon, 12 Aug 2013 09:56:15 -0400
Message-ID: <20130812135615.GA28183@thunk.org>
References: <1376314744-17678-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@inktank.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42693 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab3HLN4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Aug 2013 09:56:19 -0400
Content-Disposition: inline
In-Reply-To: <1376314744-17678-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 12, 2013 at 03:39:04PM +0200, Jan Kara wrote:
> When jbd2_journal_dirty_metadata() returns error,
> __ext4_handle_dirty_metadata() stops the handle. However callers of this
> function do not count with that fact and still happily used now freed
> handle. This use after free can result in various issues but very likely
> we oops soon.
> 
> The motivation of adding __ext4_journal_stop() into
> __ext4_handle_dirty_metadata() in commit 9ea7a0df seems to be only to
> improve error reporting. So replace __ext4_journal_stop() with
> ext4_journal_abort_handle() which was there before that commit and add
> WARN_ON_ONCE() to dump stack to provide useful information.
> 
> Reported-by: Sage Weil <sage@inktank.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
