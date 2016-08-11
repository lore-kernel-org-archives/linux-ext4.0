From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/11] ext4: Properly align shifted xattrs when expanding
 inodes
Date: Thu, 11 Aug 2016 13:32:46 -0400
Message-ID: <20160811173246.GC10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	stable@vger.kernel.org#4.4.x-
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45562 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbcHKRcs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:32:48 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:47PM +0200, Jan Kara wrote:
> We did not count with the padding of xattr value when computing desired
> shift of xattrs in the inode when expanding i_extra_isize. As a result
> we could create unaligned start of inline xattrs. Account for alignment
> properly.
> 
> CC: <stable@vger.kernel.org> # 4.4.x-
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
