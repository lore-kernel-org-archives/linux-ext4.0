From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/11] ext4: Replace bogus assertion in
 ext4_xattr_shift_entries()
Date: Thu, 11 Aug 2016 13:33:46 -0400
Message-ID: <20160811173346.GH10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-9-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45632 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcHKRds (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:33:48 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-9-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:52PM +0200, Jan Kara wrote:
> We were checking whether computed offsets do not exceed end of block in
> ext4_xattr_shift_entries(). However this does not make sense since we
> always only decrease offsets. So replace that assertion with a check
> whether we really decrease xattrs value offsets.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
