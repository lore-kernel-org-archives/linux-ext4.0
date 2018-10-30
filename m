Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44110 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbeJ3XiC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 Oct 2018 19:38:02 -0400
Date: Tue, 30 Oct 2018 10:44:10 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] jbd2: Avoid long hold times of j_state_lock while
 committing a transaction
Message-ID: <20181030144410.GG15839@thunk.org>
References: <20181016094248.21359-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181016094248.21359-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2018 at 11:42:48AM +0200, Jan Kara wrote:
> We can hold j_state_lock for writing at the beginning of
> jbd2_journal_commit_transaction() for a rather long time (reportedly for
> 30 ms) due cleaning revoke bits of all revoked buffers under it. The
> handling of revoke tables as well as cleaning of t_reserved_list, and
> checkpoint lists does not need j_state_lock for anything. Furthermore
> the transaction is in T_LOCKED state and we waited for all outstanding
> handles so nobody is going to be adding anything to the transaction.
> 
> Just drop the lock for unnecessary operations.
> 
> Reported-and-tested-by: Adrian Hunter <adrian.hunter@intel.com>
> Suggested-by: "Theodore Y. Ts'o" <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
