From: Theodore Tso <tytso@mit.edu>
Subject: Re: Possible ext2 bug with large sparse files?
Date: Tue, 5 Jun 2007 09:56:06 -0400
Message-ID: <20070605135606.GE12755@thunk.org>
References: <E1HvY6M-000Ai0-Ff@oceanus.uk.clara.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mark Knibbs <markk@clara.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43850 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761554AbXFEN4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jun 2007 09:56:15 -0400
Content-Disposition: inline
In-Reply-To: <E1HvY6M-000Ai0-Ff@oceanus.uk.clara.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 05, 2007 at 01:25:29PM +0100, Mark Knibbs wrote:
> For whatever reason, it seems the maximum file size for that
> partition is 17,247,252,480 bytes. In itself that behaviour isn't 
> necessarily a bug; but if you have any clue how the ext2 maximum file size 
> is related (or not) to the amount of free space or the volume size, please 
> let me know!

You're using a filesystem with a 1k blocksize, and that's the cause of
the limit.  The maximum number of 1k blocks that can be addressed
using the direct/indirect scheme is:

	12 + 256 + 256*256 + 256*256*256 = 16843020 blocks

or
	16843020 blocks * 1024 bytes/block =  17,247,252,480 bytes

Unless you are using a really tiny filesystem, you really don't want
to be using 1k block sizes; in addition to imposing this 16GB file
size limit, it also makes the filesystem much more inefficient for
large files.

Regards,

						- Ted
