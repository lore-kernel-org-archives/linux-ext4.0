From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/11] ext4: Fix xattr shifting when expanding inodes
Date: Thu, 11 Aug 2016 13:32:19 -0400
Message-ID: <20160811173219.GA10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	stable@vger.kernel.org#4.4.x-
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45534 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbcHKRcY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:32:24 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:45PM +0200, Jan Kara wrote:
> The code in ext4_expand_extra_isize_ea() treated new_extra_isize
> argument sometimes as the desired target i_extra_isize and sometimes as
> the amount by which we need to grow current i_extra_isize. These happen
> to coincide when i_extra_isize is 0 which used to be the common case and
> so nobody noticed this until recently when we added i_projid to the
> inode and so i_extra_isize now needs to grow from 28 to 32 bytes.
> 
> The result of these bugs was that we sometimes unnecessarily decided to
> move xattrs out of inode even if there was enough space and we often
> ended up corrupting in-inode xattrs because arguments to
> ext4_xattr_shift_entries() were just wrong. This could demonstrate
> itself as BUG_ON in ext4_xattr_shift_entries() triggering.
> 
> Fix the problem by introducing new isize_diff variable and use it where
> appropriate.
> 
> CC: <stable@vger.kernel.org> # 4.4.x-
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
