From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] ext4: Use i_mutex to serialize unaligned AIO DIO
Date: Tue, 8 Mar 2016 22:53:46 -0500
Message-ID: <20160309035346.GB3150@thunk.org>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
 <1455897582-13292-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49166 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbcCIDxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2016 22:53:49 -0500
Content-Disposition: inline
In-Reply-To: <1455897582-13292-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 04:59:38PM +0100, Jan Kara wrote:
> Currently we've used hashed aio_mutex to serialize unaligned AIO DIO.
> However the code cleanups that happened after 2011 when the lock was
> introduced made aio_mutex acquired at almost the same places where we
> already have exclusion using i_mutex. So just use i_mutex for the
> exclusion of unaligned AIO DIO.
> 
> The change moves waiting for pending unwritten extent conversion under
> i_mutex. That makes special handling of O_APPEND writes unnecessary and
> also avoids possible livelocking of unaligned AIO DIO with aligned one
> (nothing was preventing contiguous stream of aligned AIO DIOs to let
> unaligned AIO DIO wait forever).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
