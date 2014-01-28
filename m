From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: inline_data feature
Date: Tue, 28 Jan 2014 20:20:11 +0800
Message-ID: <20140128122011.GA8083@gmail.com>
References: <loom.20140122T171340-153@post.gmane.org>
 <loom.20140125T212226-499@post.gmane.org>
 <20140126032909.GA24834@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ian Nartowicz <claws@nartowicz.co.uk>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57984 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaA1MPc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jan 2014 07:15:32 -0500
Received: by mail-pd0-f177.google.com with SMTP id x10so284964pdj.22
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jan 2014 04:15:32 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140126032909.GA24834@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 25, 2014 at 10:29:09PM -0500, Theodore Ts'o wrote:
> On Sat, Jan 25, 2014 at 08:22:56PM +0000, Ian Nartowicz wrote:
> > Ian Nartowicz <claws <at> nartowicz.co.uk> writes:
> > 
> > > 
> > > I have been trying to test the inline_data feature of EXT4.  I am using
> > > kernel 3.9.5 and have compiled e2fsprogs from the pu branch.  I am able to
> > > set the feature and apparently to use the filesystem, but I get a lot of
> > > warnings from the kernel and fsck reports several errors and then crashes.
> > > 
> > I wonder if I might have compiled against the wrong (clib?) headers?  Are
> > you aware of any version dependencies in the pu branch tools?
> 
> I doubt it; this looks like a straightforward memory bug of some kind
> (i.e., use after free, etc.)
> 
> Could you try running e2fsck under valgrind?  And could you also
> confirm the git commit ID of the e2fsprogs pu branch that you used to
> compile it?
> 
> A compressed raw e2image file would be useful as well, but one problem
> with inline data is that a raw e2image file will have some amount of
> file data (for the small files that are using inline data) in the
> e2image file.  We should probably look at teaching e2image to can zero
> out the contents of inline data files....

Ian,
Thanks for reporting the problem.  That would be great if you can run
e2fsck under valgrind as Ted suggested because it would help us to find
the root cause.

Further, Here is the latest patch set for making e2fsprogs support
inline_data feature [1], which isn't applied into e2fsprogs/pu branch.
This patch set is against e2fsprogs/next branch.  Could you please give
it a try?  Unfortunately the patch set contains a lot of patches.  I am
happy to provide a tar file to you.  Please let me know if you need any
help.

1. http://www.spinics.net/lists/linux-ext4/msg40852.html

Ted,
It seems that we should teach e2image to zero out the inline data files.
I will put this in my TODO list but I am afraid that it doesn't have a
higher priority. :(

Regards,
                                                - Zheng
