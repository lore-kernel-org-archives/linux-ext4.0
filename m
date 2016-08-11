From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/11] ext4: Fix xattr shifting when expanding inodes (2)
Date: Thu, 11 Aug 2016 13:32:37 -0400
Message-ID: <20160811173237.GB10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	stable@vger.kernel.org#4.4.x-
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45548 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbcHKRck (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:32:40 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:46PM +0200, Jan Kara wrote:
> When multiple xattrs need to be moved out of inode, we did not properly
> recompute total size of xattr headers in the inode and the new header
> position. Thus when moving the second and further xattr we asked
> ext4_xattr_shift_entries() to move too much and from the wrong place,
> resulting in possible xattr value corruption or general memory
> corruption.
> 
> CC: <stable@vger.kernel.org> # 4.4.x-
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
