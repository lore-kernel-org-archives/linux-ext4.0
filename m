From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: avoid hangs in
 ext4_da_should_update_i_disksize()
Date: Tue, 13 Dec 2011 21:44:35 -0500
Message-ID: <20111214024435.GB6276@thunk.org>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
 <1323656828-24465-2-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54874 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1LNCok (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 21:44:40 -0500
Content-Disposition: inline
In-Reply-To: <1323656828-24465-2-git-send-email-aarcange@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 12, 2011 at 03:27:07AM +0100, Andrea Arcangeli wrote:
> If the pte mapping in generic_perform_write() is unmapped between
> iov_iter_fault_in_readable() and iov_iter_copy_from_user_atomic(), the
> "copied" parameter to ->end_write can be zero. ext4 couldn't cope with
> it with delayed allocations enabled. This skips the i_disksize
> enlargement logic if copied is zero and no new data was appeneded to
> the inode.
      ...
> 
> This is 100% reproducible with some autonuma development code tuned in
> a very aggressive manner (not normal way even for knumad) which does
> "exotic" changes to the ptes. It wouldn't normally trigger but I don't
> see why it can't happen normally if the page is added to swap cache in
> between the two faults leading to "copied" being zero (which then
> hangs in ext4). So it should be fixed. Especially possible with lumpy
> reclaim (albeit disabled if compaction is enabled) as that would
> ignore the young bits in the ptes.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks, applied.

						- Ted
