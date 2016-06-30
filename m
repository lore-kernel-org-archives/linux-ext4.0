From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] jbd2: Track more dependencies on transaction commit
Date: Thu, 30 Jun 2016 11:45:04 -0400
Message-ID: <20160630154504.GF2028@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40408 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbcF3PpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2016 11:45:12 -0400
Content-Disposition: inline
In-Reply-To: <1466073736-30447-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 16, 2016 at 12:42:16PM +0200, Jan Kara wrote:
> So far we were tracking only dependency on transaction commit due to
> starting a new handle (which may require commit to start a new
> transaction). Now add tracking also for other cases where we wait for
> transaction commit. This way lockdep can catch deadlocks e. g. because we
> call jbd2_journal_stop() for a synchronous handle with some locks held
> which rank below transaction start.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
