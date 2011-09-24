From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add better example about how to compress e2image raw
 image
Date: Sat, 24 Sep 2011 12:31:53 -0400
Message-ID: <20110924163153.GB2779@thunk.org>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com>
 <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca>
 <20110923205124.GD26962@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60344 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1IXQcA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Sep 2011 12:32:00 -0400
Content-Disposition: inline
In-Reply-To: <20110923205124.GD26962@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 05:51:24PM -0300, Carlos Maiolino wrote:
> On Fri, Sep 23, 2011 at 02:24:23PM -0600, Andreas Dilger wrote:
> > On 2011-09-23, at 12:47 PM, Carlos Maiolino wrote:
> > > The current example in the man page uses bzip2 to compress
> > > the raw image file created by the e2image, but, bzip2 does
> > > not honors sparse files, which causes the image to have the
> > > same size of the filesystem.
> > > Using tar together with bzip2 will make the compressed file
> > > to honor the sparsed file, which makes it more transportable
> > > than the current one if the filesystem is large.

The problem with using tar is that it requires extra disk space by the
user --- somewhere a bit more than double the extra disk space
(because you need to have space for the hda1.e2i file before it gets
compressed).  For very large file systems, this can be quite
significant.  My general philosophy has been to make things easy as
possible for the users as being more important for the developers.

For the developers, we do have contrib/make-sparse.c.  All we have to do is:

    bunzip2 < hda1.e2i.bz2 | make-sparse hda1.e2i

... and this creates a sparse file in hda1.e2i.

> > Even better would be the use of the QCOW2 format that Lukas added,
> > if it could also be operated on directly by the e2fsprogs utils (I
> > don't know if that is possible or not).
> > 
> The QCOW2 format can only be operated with qcow2 capable tools like
> > qemu-img to use directly with e2fsprogs tools, we still need to
> > use raw images.

Yeah, it would be nice if we had an io_manager implementation that
understood qcow2, which could then be used by dumpe2fs and debugfs.
Hopefully at some point someone will implement it.

						- Ted
