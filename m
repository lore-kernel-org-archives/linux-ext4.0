From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/11] ext4: Factor out xattr moving
Date: Thu, 11 Aug 2016 13:33:54 -0400
Message-ID: <20160811173354.GI10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-10-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45644 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcHKRd4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:33:56 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-10-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:53PM +0200, Jan Kara wrote:
> Factor out function for moving xattrs from inode into external xattr
> block from ext4_expand_extra_isize_ea(). That function is already quite
> long and factoring out this rather standalone functionality helps
> readability.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
