From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Date: Wed, 26 Nov 2014 11:23:28 -0800
Message-ID: <20141126192328.GA20436@infradead.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaKZTX2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2014 14:23:28 -0500
Content-Disposition: inline
In-Reply-To: <1416997437-26092-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As mentioned last round please move the addition of the is_readonly
operation to the first thing in the series, so that the ordering makes
more sense.

Second I think this patch is incorrect for XFS - XFS uses ->update_time
to set the time stampst in the dinode.  These two need to be coherent
as we can write out a dirty inode any time, so it needs to have the
timestamp uptodate.

Third update_time now calls mark_inode_dirty unconditionally, while
previously it wasn't called when ->update_time was set.  At least
for XFS that's a major change in behavior as XFS never used VFS dirty
tracking for metadata updates.

