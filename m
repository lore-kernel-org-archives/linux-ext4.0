From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 13:22:58 -0500
Message-ID: <20110228182258.GB28617@thunk.org>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
 <20110228101454.GE4834@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43304 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab1B1SXJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 13:23:09 -0500
Content-Disposition: inline
In-Reply-To: <20110228101454.GE4834@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 28, 2011 at 11:14:55AM +0100, Rogier Wolff wrote:
> If the cleanup/fixup is really neccesary, do so in in-core buffers of
> the filesystem. Write the infrastructure that allows us to have dirty
> buffers that MAY NOT (yet?!?) be written to the device. This will also
> solve the problem of journal recovery on readonly mount of a root
> filesystem. when it has been fscked, and it's remounted rw, we can
> remove the ban on the writeback of the dirty buffers.

That would be an interesting and useful thing to add, but it's not a
trivial change.  There is the risk that if the journal is very large,
and system memory is very, that there might not be enough memory to
hold all of the dirty buffers (or it might handicap the machine).
That shouldn't be an issue on reasonably configured machines, but as
we know, not all file servers are reasonably configured (see previous
discussions about tdb :-)

If someone want to work on this as a project, that would be great, but
to be honest it's not high on my priority list at the moment.

      	     	      	      	 	  - Ted
