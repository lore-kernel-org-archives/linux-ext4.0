From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Wed, 25 Aug 2010 21:21:17 -0400
Message-ID: <20100826012117.GP4453@thunk.org>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
 <20100824131735.GD3713@quack.suse.cz>
 <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
 <20100825230442.GH2738@quack.suse.cz>
 <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
 <20100826003657.GN4453@thunk.org>
 <6B0D8B5D-C576-4DC2-B390-9D1EB8B6A5BA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48241 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab0HZBVZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Aug 2010 21:21:25 -0400
Content-Disposition: inline
In-Reply-To: <6B0D8B5D-C576-4DC2-B390-9D1EB8B6A5BA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 25, 2010 at 06:55:49PM -0600, Andreas Dilger wrote:
> 
> I think you are missing the point.  I don't think it matters which
> mke2fs is in use.  The problem is that ext3_iget() has a workaround
> for this 5-year-old mke2fs bug that is actively causing a loss of
> xattr data if lost+found is reallocated.

Ah, OK.  But it's still the case that the right answer at this point
is to make ext3 code conform to ext4, and drop the workaround
altogether.

						- Ted
