Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38858 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbeLDEbY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Dec 2018 23:31:24 -0500
Date: Mon, 3 Dec 2018 23:31:17 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
        "Hunter, Adrian" <adrian.hunter@intel.com>
Subject: Re: [PATCH v2] jbd2: Avoid long hold times of j_state_lock while
 committing a transaction
Message-ID: <20181204043117.GB4981@thunk.org>
References: <20181108122938.10688-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108122938.10688-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2018 at 01:29:38PM +0100, Jan Kara wrote:
> We can hold j_state_lock for writing at the beginning of
> jbd2_journal_commit_transaction() for a rather long time (reportedly for
> 30 ms) due cleaning revoke bits of all revoked buffers under it. The
> handling of revoke tables as well as cleaning of t_reserved_list, and
> checkpoint lists does not need j_state_lock for anything. It is only
> needed to prevent new handles from joining the transaction. Generally
> T_LOCKED transaction state prevents new handles from joining the
> transaction - except for reserved handles which have to allowed to join
> while we wait for other handles to complete.
> 
> To prevent reserved handles from joining the transaction while cleaning
> up lists, add new transaction state T_SWITCH and watch for it when
> starting reserved handles. With this we can just drop the lock for
> operations that don't need it.
> 
> Reported-and-tested-by: Adrian Hunter <adrian.hunter@intel.com>
> Suggested-by: "Theodore Y. Ts'o" <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
