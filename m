From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] ext4: update EOFBLOCKS flag on fallocate properly
Date: Tue, 25 Oct 2011 08:22:22 -0400
Message-ID: <20111025122222.GG31921@thunk.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
 <1319144939-28801-7-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54782 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab1JYMW2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 08:22:28 -0400
Content-Disposition: inline
In-Reply-To: <1319144939-28801-7-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 01:08:59AM +0400, Dmitry Monakhov wrote:
> EOFBLOCK_FL should be updated if called w/o FALLOCATE_FL_KEEP_SIZE
> Currently it happens only if new extent was allocated
> TESTCASE:
> fallocate test_file -n -l4096
> fallocate test_file -l4096
> Last fallocate cmd has updated size, but keept EOFBLOCK_FL set. And fsck
> will complain about that.
> 
> Also remove ping pong in ext4_fallocate() in case of new extents, where
> ext4_ext_map_blocks() clear EOFBLOCKS bit, and later
> ext4_falloc_update_inode() restore it again.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

					- Ted
