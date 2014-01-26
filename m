From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: inline_data feature
Date: Sat, 25 Jan 2014 22:29:09 -0500
Message-ID: <20140126032909.GA24834@thunk.org>
References: <loom.20140122T171340-153@post.gmane.org>
 <loom.20140125T212226-499@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ian Nartowicz <claws@nartowicz.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51539 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaAZD3M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Jan 2014 22:29:12 -0500
Content-Disposition: inline
In-Reply-To: <loom.20140125T212226-499@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 25, 2014 at 08:22:56PM +0000, Ian Nartowicz wrote:
> Ian Nartowicz <claws <at> nartowicz.co.uk> writes:
> 
> > 
> > I have been trying to test the inline_data feature of EXT4.  I am using
> > kernel 3.9.5 and have compiled e2fsprogs from the pu branch.  I am able to
> > set the feature and apparently to use the filesystem, but I get a lot of
> > warnings from the kernel and fsck reports several errors and then crashes.
> > 
> I wonder if I might have compiled against the wrong (clib?) headers?  Are
> you aware of any version dependencies in the pu branch tools?

I doubt it; this looks like a straightforward memory bug of some kind
(i.e., use after free, etc.)

Could you try running e2fsck under valgrind?  And could you also
confirm the git commit ID of the e2fsprogs pu branch that you used to
compile it?

A compressed raw e2image file would be useful as well, but one problem
with inline data is that a raw e2image file will have some amount of
file data (for the small files that are using inline data) in the
e2image file.  We should probably look at teaching e2image to can zero
out the contents of inline data files....

Many thanks,

					- Ted
