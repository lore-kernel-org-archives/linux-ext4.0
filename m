From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Wed, 25 Aug 2010 20:36:57 -0400
Message-ID: <20100826003657.GN4453@thunk.org>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
 <20100824131735.GD3713@quack.suse.cz>
 <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
 <20100825230442.GH2738@quack.suse.cz>
 <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37088 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0HZAhD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Aug 2010 20:37:03 -0400
Content-Disposition: inline
In-Reply-To: <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 25, 2010 at 05:39:11PM -0600, Andreas Dilger wrote:
> 
> The fix to e2fsck for this issue has been around for a long time,
> AFAIK.  It was only needed in the kernel while the broken mke2fs was
> in wide use, and before a fixed e2fsck was available.

The mke2fs in question was fixed in e2fsprogs 1.37, over five years
ago.  Mizuma-san, why are you using such an __ancient__ mke2fs?  It
would seem that instead of fixing the kernel, the better thing to do
is to fix your version of e2fsprogs.  There have been enough other bug
fixes to e2fsck that using such an ancient version of e2fsck, if you
are willing to update the kernel, seems to not make a whole lot of
sense.

I certainly don't see the point of fixing making any changes in ext4
to accomodate such a change, since e2fsprogs which is that old won't
support ext4 file system features anyway.

							- Ted
