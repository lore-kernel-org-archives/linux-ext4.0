From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] jbd2: Speedup jbd2_journal_get_[write|undo]_access()
Date: Wed, 17 Jun 2015 18:56:46 +0200
Message-ID: <20150617165646.GG1614@quack.suse.cz>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-5-git-send-email-jack@suse.cz>
 <20150608164726.GM19168@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbbFQQ4v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2015 12:56:51 -0400
Content-Disposition: inline
In-Reply-To: <20150608164726.GM19168@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-06-15 12:47:26, Ted Tso wrote:
> On Thu, Apr 02, 2015 at 03:58:19PM +0200, Jan Kara wrote:
> > jbd2_journal_get_write_access() and jbd2_journal_get_create_access() are
> > frequently called for buffers that are already part of the running
> > transaction - most frequently it is the case for bitmaps, inode table
> > blocks, and superblock. Since in such cases we have nothing to do, it is
> > unfortunate we still grab reference to journal head, lock the bh, lock
> > bh_state only to find out there's nothing to do.
> > 
> > Improving this is a bit subtle though since until we find out journal
> > head is attached to the running transaction, it can disappear from under
> > us because checkpointing / commit decided it's no longer needed. We deal
> > with this by protecting journal_head slab with RCU. We still have to be
> > careful about journal head being freed & reallocated within slab and
> > about exposing journal head in consistent state (in particular
> > b_modified and b_frozen_data must be in correct state before we allow
> > user to touch the buffer).
> > 
> > FIXME: Performance data.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Applied, so we can start getting some testing on this patch.  Did you
> ever get performance data?

Yes. Here are results for reaim fserver workload for 32 core machine with
128 GB of ram with ext4 on ramdisk:
Procs Vanilla    Patched
1      20420.688  21155.556
21     49684.704 178934.074
41     84630.364 196647.482
61    106344.284 204831.652
81    120751.370 214842.428
101   131585.450 208761.832
121   138092.078 212741.648
141   142271.578 212118.502
161   146008.364 213731.388
181   149569.494 216121.444

Numbers are operations per second so larger is better. You can see that
for 21 processes we get increase by 260% in the number operations. Also the
total maximum of operations the machine is able to achieve increases by
44% because of overall lower CPU overhead.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
