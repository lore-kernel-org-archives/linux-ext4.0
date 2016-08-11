From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/11] ext4: Fixup free space calculations when expanding
 inodes
Date: Thu, 11 Aug 2016 13:33:09 -0400
Message-ID: <20160811173309.GE10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45590 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbcHKRdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:33:11 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-6-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:49PM +0200, Jan Kara wrote:
> Conditions checking whether there is enough free space in an xattr block
> and when xattr is large enough to make enough space in the inode forgot
> to account for the fact that inode need not be completely filled up with
> xattrs. Thus we could move unnecessarily many xattrs out of inode or
> even falsely claim there is not enough space to expand the inode. We
> also forgot to update the amount of free space in xattr block when moving
> more xattrs and thus could decide to move too big xattr resulting in
> unexpected failure.
> 
> Fix these problems by properly updating free space in the inode and
> xattr block as we move xattrs. To simplify the math, avoid shifting
> xattrs after removing each one xattr and instead just shift xattrs only
> once there is enough free space in the inode.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
