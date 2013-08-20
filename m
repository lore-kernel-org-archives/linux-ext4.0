From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 5/5] ext4: Defer mmap cmtime update until writeback
Date: Tue, 20 Aug 2013 12:38:49 +1000
Message-ID: <20130820023849.GF6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
 <d59d6c9790bd3c36b93343ed91be5e0cda7e5f09.1376679411.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
	Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5989 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab3HTCiy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Aug 2013 22:38:54 -0400
Content-Disposition: inline
In-Reply-To: <d59d6c9790bd3c36b93343ed91be5e0cda7e5f09.1376679411.git.luto@amacapital.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 16, 2013 at 04:22:12PM -0700, Andy Lutomirski wrote:
> A fancier implementation could probably avoid an extra journal
> transaction by adding a mapping_test_clear_cmtime call in
> ext4_writepages, but this should already be a considerable
> improvement -- we'll start one transaction per writepages call
> instead of one per page.

I'd like to see more than just an ext4 implementation - btrfs and
XFS are the other main filesystems that should behave identically.

Also, it's worthwhile to write a generic xfstest to ensure that they
all update the timestamp appropriately - if its' in xfstests, then
we can basically guarantee that it won't get randomly regressed in
future, and other filesystems can be easily verified as well sa
their implement this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
