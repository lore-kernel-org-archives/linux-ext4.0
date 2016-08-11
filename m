From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/11] ext4: Avoid deadlock when expanding inode size
Date: Thu, 11 Aug 2016 13:32:55 -0400
Message-ID: <20160811173255.GD10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	stable@vger.kernel.org#4.4.x-
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45574 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbcHKRc5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:32:57 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:48PM +0200, Jan Kara wrote:
> When we need to move xattrs into external xattr block, we call
> ext4_xattr_block_set() from ext4_expand_extra_isize_ea(). That may end
> up calling ext4_mark_inode_dirty() again which will recurse back into
> the inode expansion code leading to deadlocks.
> 
> Protect from recursion using EXT4_STATE_NO_EXPAND inode flag and move
> its management into ext4_expand_extra_isize_ea() since its manipulation
> is safe there (due to xattr_sem) from possible races with
> ext4_xattr_set_handle() which plays with it as well.
> 
> CC: <stable@vger.kernel.org> # 4.4.x-
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
