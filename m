From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: Fix type declaration of
 ext4_validate_block_bitmap
Date: Wed, 28 Aug 2013 16:01:15 -0400
Message-ID: <20130828200115.GH27079@thunk.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235546.24017.98557.stgit@blackbox.djwong.org>
 <20130724071201.GA3474@gmail.com>
 <20130726160613.GA25936@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50835 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab3H1UBS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 16:01:18 -0400
Content-Disposition: inline
In-Reply-To: <20130726160613.GA25936@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 26, 2013 at 09:06:13AM -0700, Darrick J. Wong wrote:
> > > @@ -352,7 +352,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
> >                                           ^^^
> > It seems that this function also needs to be fixed.
> 
> Yep.  I'll get that in the next version, thank you.

I've applied this patch with addition of a fix for s/unsigned int/ext4_group_t/
in the ext4_valid_block_bitmap() function as well.

Thanks,

						- Ted
