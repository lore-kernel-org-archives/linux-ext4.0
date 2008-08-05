From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem with delayed allocation
Date: Tue, 5 Aug 2008 09:47:23 -0400
Message-ID: <20080805134722.GA12544@mit.edu>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804163505.GE9397@skywalker> <20080805064428.GB8569@mit.edu> <20080805065217.GF9397@skywalker> <20080805132133.GA15568@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40253 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758545AbYHENr1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 09:47:27 -0400
Content-Disposition: inline
In-Reply-To: <20080805132133.GA15568@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2008 at 06:51:33PM +0530, Aneesh Kumar K.V wrote:
> This should not be needed. I was trying to force the pages to writeback.
> generic_sync_sb_inodes actually move  the inode to s_dirty if the
> pages_skipped differ after a writeback. But the confusing part is we
> are not looking at s_dirty list again. We move s_dirty and s_more_io to s_io
> only once in queue_io

Yes, but ext4_da_writepages() gets called twice in the __fsync_super()
code path, right?  Once with wbc->sync_mode set to WB_SYNC_HOLD, and
once with wbc->sync_mode set to wbc->sync_mode set to WB_SYNC_ALL,
corresponding to sync_inodes_sb() getting called twice, once with
wait=0 and once with wait=1.

						- Ted
