From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: mark multi-page IO complete on mapping
 failure
Date: Sat, 26 Feb 2011 13:54:05 -0500
Message-ID: <20110226185405.GE2924@thunk.org>
References: <1298064699-17987-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51934 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab1BZSyK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Feb 2011 13:54:10 -0500
Content-Disposition: inline
In-Reply-To: <1298064699-17987-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 18, 2011 at 01:31:38PM -0800, Curt Wohlgemuth wrote:
> In mpage_da_map_and_submit(), if we have a delayed block
> allocation failure from ext4_map_blocks(), we need to mark
> the IO as complete, by setting
> 
>       mpd->io_done = 1;
> 
> Otherwise, we could end up submitting the pages in an outer
> loop; since they are unlocked on mapping failure in
> ext4_da_block_invalidatepages(), this will cause a bug check
> in mpage_da_submit_io().
> 
> I tested this by injected failures into ext4_map_blocks().
> Without this patch, a simple fsstress run will bug check;
> with the patch, it works fine.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Thanks, added to the ext4 patch queue.

					- Ted
