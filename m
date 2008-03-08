From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] JBD ordered mode rewrite
Date: Sat, 8 Mar 2008 07:14:20 -0500
Message-ID: <20080308121420.GA17812@infradead.org>
References: <20080306174209.GA14193@duck.suse.cz> <20080307235210.GM1881@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYCHMOW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 07:14:22 -0500
Content-Disposition: inline
In-Reply-To: <20080307235210.GM1881@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2008 at 04:52:10PM -0700, Andreas Dilger wrote:
> I'm looking at what implications this has for delayed allocation in ext4,
> because the vast majority of file data will be unmapped in that case
> and a journal commit in ordered mode will no longer cause the data to
> be flushed to disk.

The buffers shouldn't be unmapped.  They are accounted for and doing
the delalloc conversion is easier than really allocating blocks for
truely unmapped blocks.  You should probably reuse BH_Delay for that
as it has all the right handling in buffer.c in place due to XFS.

Also on any filesystem with ->page_mkwrite implemented unmapped buffers
should be entirely gone because we now have the proper early
reservation / allocation infrastructure in place.

