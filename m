From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Bail early when clearing inode journal flag fails
Date: Thu, 30 Oct 2014 10:36:56 -0400
Message-ID: <20141030143656.GB31927@thunk.org>
References: <1414069543-29853-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53199 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760364AbaJ3OhA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Oct 2014 10:37:00 -0400
Content-Disposition: inline
In-Reply-To: <1414069543-29853-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 23, 2014 at 03:05:43PM +0200, Jan Kara wrote:
> When clearing inode journal flag, we call jbd2_journal_flush() to force
> all the journalled data to their final locations. Currently we ignore
> when this fails and continue clearing inode journal flag. This isn't a
> big problem because when jbd2_journal_flush() fails, journal is likely
> aborted anyway. But it can still lead to somewhat confusing results so
> rather bail out early.
> 
> Coverity-id: 989044
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
