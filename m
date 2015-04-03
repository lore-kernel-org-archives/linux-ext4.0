From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix loss of delalloc extent info in
 ext4_zero_range()
Date: Fri, 3 Apr 2015 00:14:36 -0400
Message-ID: <20150403041436.GJ10991@thunk.org>
References: <20150320235350.GA10101@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48569 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbbDCEOh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2015 00:14:37 -0400
Content-Disposition: inline
In-Reply-To: <20150320235350.GA10101@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 20, 2015 at 07:53:50PM -0400, Eric Whitney wrote:
> In ext4_zero_range(), removing a file's entire block range from the
> extent status tree removes all records of that file's delalloc extents.
> The delalloc accounting code uses this information, and its loss can
> then lead to accounting errors and kernel warnings at writeback time and
> subsequent file system damage.  This is most noticeable on bigalloc
> file systems where code in ext4_ext_map_blocks() handles cases where
> delalloc extents share clusters with a newly allocated extent.
> 
> Because we're not deleting a block range and are correctly updating the
> status of its associated extent, there is no need to remove anything
> from the extent status tree.
> 
> When this patch is combined with an unrelated bug fix for
> ext4_zero_range(), kernel warnings and e2fsck errors reported during
> xfstests runs on bigalloc filesystems are greatly reduced without
> introducing regressions on other xfstests-bld test scenarios.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

					- Ted
