From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] e2fsck: don't flush the FS unless it's actually dirty
Date: Tue, 12 Aug 2014 14:39:49 -0400
Message-ID: <20140812183949.GH12871@thunk.org>
References: <20140812171707.GI2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dan Jacobson <jidanni@jidanni.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56771 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbaHLSjv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2014 14:39:51 -0400
Content-Disposition: inline
In-Reply-To: <20140812171707.GI2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2014 at 10:17:07AM -0700, Darrick J. Wong wrote:
> ext2fs_flush2() unconditionally writes the block group descriptors to
> disk even if the underlying FS isn't marked dirty.  This causes the
> following error message on a fsck -n run:...
> 
> v2: Fix test to use $CRCSUM instead of md5sum.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

As it turns out, I was wrong; there were other users of md5sum in the
tests that I had forgotten about.  Now that we have crcsum, it makes
sense to convert them over to use md5sum as well, so I'll do that.

Thanks again,

						- Ted
