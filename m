From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] jbd2: Move lockdep tracking to journal_s
Date: Thu, 30 Jun 2016 11:40:05 -0400
Message-ID: <20160630154005.GE2028@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40256 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430AbcF3PkK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2016 11:40:10 -0400
Content-Disposition: inline
In-Reply-To: <1466073736-30447-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 16, 2016 at 12:42:15PM +0200, Jan Kara wrote:
> Currently lockdep map is tracked in each journal handle. To be able to
> expand lockdep support to cover also other cases where we depend on
> transaction commit and where handle is not available, move lockdep map
> into struct journal_s. Since this makes the lockdep map shared for all
> handles, we have to use rwsem_acquire_read() for acquisitions now.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.  I added documentation for j_trans_commit_map to keep
the kbuild checker happy.

						- Ted
