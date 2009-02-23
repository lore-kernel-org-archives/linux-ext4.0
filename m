From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3/4: Clear pagep after write_begin() has failed
Date: Sun, 22 Feb 2009 22:12:30 -0500
Message-ID: <20090223031230.GA19739@mit.edu>
References: <1234898659-4686-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42671 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZBWDMf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Feb 2009 22:12:35 -0500
Content-Disposition: inline
In-Reply-To: <1234898659-4686-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 17, 2009 at 10:24:19PM +0300, Dmitri Monakhov wrote:
> Seems there is no strict rule to for this case. In fact everybody
> just ignored this variable after write_begin() has failed.
> This was true until ext4_defrag_partial(). So let's follows simple
> rule similar to block_write_begin().

I've checked the latest ext4_defrag_partial, and it doesn't reference
the page variable if write_begin() failed....

						- Ted
