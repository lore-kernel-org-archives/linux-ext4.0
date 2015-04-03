From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: don't release reserved space for previously
 allocated cluster
Date: Fri, 3 Apr 2015 00:18:48 -0400
Message-ID: <20150403041848.GK10991@thunk.org>
References: <20150324213929.GB29607@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48576 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbbDCESu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2015 00:18:50 -0400
Content-Disposition: inline
In-Reply-To: <20150324213929.GB29607@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 24, 2015 at 05:39:29PM -0400, Eric Whitney wrote:
> When xfstests' auto group is run on a bigalloc filesystem with a
> 4.0-rc3 kernel, e2fsck failures and kernel warnings occur for some
> tests. e2fsck reports incorrect iblocks values, and the warnings
> indicate that the space reserved for delayed allocation is being
> overdrawn at allocation time.
> 
> Some of these errors occur because the reserved space is incorrectly
> decreased by one cluster when ext4_ext_map_blocks satisfies an
> allocation request by mapping an unused portion of a previously
> allocated cluster.  Because a cluster's worth of reserved space was
> already released when it was first allocated, it should not be released
> again.
> 
> This patch appears to correct the e2fsck failure reported for
> generic/232 and the kernel warnings produced by ext4/001, generic/009,
> and generic/033.  Failures and warnings for some other tests remain to
> be addressed.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
