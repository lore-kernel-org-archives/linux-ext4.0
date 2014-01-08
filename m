From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A proposal for making ext4's journal more SMR (and flash)
 friendly
Date: Wed, 8 Jan 2014 18:37:52 -0500
Message-ID: <20140108233752.GD17750@thunk.org>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
 <20140108221430.GB21663@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46937 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757355AbaAHXiD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 18:38:03 -0500
Content-Disposition: inline
In-Reply-To: <20140108221430.GB21663@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 08, 2014 at 11:14:30PM +0100, Jan Kara wrote:
>   So when I was thinking about this (already couple of years ago) the thing
> which stopped me was the question at which layer we should do the
> translation. Ideally we would need something at submit_bh() level but just
> wrapping submit_bh() calls inside ext4 isn't enough for stuff like symlinks
> or journalled data... Do you have any thoughts on that?

I think there are two interfaces that should handle nearly all of our
journal block mapping needs.  The functions that issue bio requests
directly tend to use ext4_get_block*() functions, and functions which
use the buffer cache uses submit_bh() (typically via ext4_getblk).
There will probably be a few exceptions, but I don't think this should
be an intractable problem.

Regards,

					- Ted
