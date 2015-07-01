From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Wed, 1 Jul 2015 08:10:14 +0200
Message-ID: <20150701061014.GA6286@dhcp22.suse.cz>
References: <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <20150625133138.GH14324@thunk.org>
 <5591097D.6010602@kyup.com>
 <20150629093640.GD28471@dhcp22.suse.cz>
 <20150630015206.GL22807@dastard>
 <20150630123033.GB4578@dhcp22.suse.cz>
 <20150630143158.GD4578@dhcp22.suse.cz>
 <20150630225851.GK7943@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Borisov <kernel@kyup.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36192 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbGAGKS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2015 02:10:18 -0400
Received: by wguu7 with SMTP id u7so27110950wgu.3
        for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2015 23:10:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150630225851.GK7943@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 01-07-15 08:58:51, Dave Chinner wrote:
[...]
> *blink*
> 
> /me re-reads again
> 
> That assumption is fundamentally broken. Filesystems use GFP_NOFS
> because the filesystem holds resources that can prevent memory
> reclaim making forwards progress if it re-enters the filesystem or
> blocks on anything filesystem related. memcg does not change that,
> and I'm kinda scared to learn that memcg plays fast and loose like
> this.
> 
> For example: IO completion might require unwritten extent conversion
> which executes filesystem transactions and GFP_NOFS allocations. The
> writeback flag on the pages can not be cleared until unwritten
> extent conversion completes. Hence memory reclaim cannot wait on
> page writeback to complete in GFP_NOFS context because it is not
> safe to do so, memcg reclaim or otherwise.

Thanks for the clarification.

> > really charge after set_page_writeback (called from ext4_bio_write_page)
> > and before the page is really submitted (when the bio is full or
> > explicitly via ext4_io_submit). I thought that io_submit_add_bh submits
> > the page but it doesn't do that necessarily.
> 
> XFS does exactly the same thing - the underlying alogrithm ext4 uses
> to build large bios efficiently was copied from XFS. And FWIW XFS has
> been using this algorithm since 2.6.15....

OK, I will mark the patch for stable then.

Thanks!
-- 
Michal Hocko
SUSE Labs
