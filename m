From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Repost (from LKML): EXT3 FS and 64K blocks error
Date: Fri, 9 Jul 2010 20:26:11 -0400
Message-ID: <20100710002611.GA17032@thunk.org>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AEE9@wdscexbe07.sc.wdc.com>
 <7D7CBABC-08DF-4D5D-9655-D378529882B0@mit.edu>
 <469D2D911E4BF043BFC8AD32E8E30F5B24AEEE@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46214 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab0GJA0O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jul 2010 20:26:14 -0400
Content-Disposition: inline
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEEE@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 09, 2010 at 03:32:22PM -0700, Daniel Taylor wrote:
> We're switching to ext4.  I just thought someone might want to take
> a look at the error message.  I can do some more testing, next
> week, if there are suggestions of what to try.

I can try to dig up the patch we used to fix 64k block sizes for ext4,
and backport it to ext3, but to be honest I'm pretty overbooked
already as it is, and in general we've been trying to keep ext3
stable, which means in practice, bug fixes only.  The question is
whether 64k blocksize support is considered a bug fix or a new
feature....  so if you're switching to ext4 anyway, I'd probably just
not bother trying to fix it for ext3...

					- Ted
