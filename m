From: Theodore Tso <tytso@mit.edu>
Subject: Re: merging of two file system
Date: Mon, 28 Jul 2008 16:04:39 -0400
Message-ID: <20080728200439.GL9378@mit.edu>
References: <425904320807270905k32264faaq5c813b73000ee5c6@mail.gmail.com> <20080727225246.GD7922@mit.edu> <5feb302e0807281147y7362a227kb7d37d713be05296@mail.gmail.com> <425904320807281211y517f8847rc93cfa6a3a13aac3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rishi agrawal <postrishi@gmail.com>, linux-ext4@vger.kernel.org,
	listar@nl.linux.org
To: Vineet Agarwal <checkout.vineet@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51157 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbYG1U3a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 16:29:30 -0400
Content-Disposition: inline
In-Reply-To: <425904320807281211y517f8847rc93cfa6a3a13aac3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2008 at 12:41:25AM +0530, Vineet Agarwal wrote:
> yeah i meant that we have to separate filesystems,
> stored for example on /dev/hda1 and /dev/hda2, and we want to combine
> the data in the two filesystems into a single filesystem /dev/hda3, or
> combining the contents of /dev/hda2 so that it is also in /dev/hda1
> 
> so is there any mechanism exist to do so either online or offline . please help

There is no direct way to do this.

How big are the filesystems involved?  The standard and easist way to
do this would be to copy /dev/hda2 to another device, then if
/dev/hda1 was created with on-line resizing inode, expanding /dev/hda1
to fill the space taken by /dev/hda2, and then simply use "cp" to copy
the contents that had previously been in /dev/hda2 into the filesystem
on /dev/hda1.

In theory it would be possible to write a program would take to
adjacent filesystems, and map out where the blocks would be once the
two partitions were combined, and then relocate blocks to make a
single filesystem.  No one has done such a thing, however, for any
filesytem.  It is definitely not a trivial thing to do, but it is not
impossible; it's not that different from some of what an off-line
resize2fs operations does, albeit maybe 3-4 times more complex.

The main thing is that no one has ever taken the time to do such a
thing, because except for truly large filesystems, it's cheaper just
to get an extra disk drive, and just copy the contents off, and then
recreate the filesystem.

							- Ted
