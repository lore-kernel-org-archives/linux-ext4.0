From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Call traces on console from a test machine
Date: Mon, 17 Nov 2008 21:24:18 -0500
Message-ID: <20081118022418.GA29975@mit.edu>
References: <491CC6E3.7070808@hq.newdream.net> <491CDF90.8070802@hq.newdream.net> <20081114170930.GI25117@mit.edu> <4921BEE2.1090700@hq.newdream.net> <20081117203001.GH14523@mit.edu> <4921E004.7040000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kelly Kane <kelly@hq.newdream.net>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54373 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbYKRC0Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Nov 2008 21:26:25 -0500
Content-Disposition: inline
In-Reply-To: <4921E004.7040000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 17, 2008 at 03:20:04PM -0600, Eric Sandeen wrote:
> 
> Ted, what do you think about putting make-sparse.c into e2fsprogs?
> Might be handy for this sort of thing, rather than searching the
> innertubes for it each time I need it ;)

I've checked it into the e2fsprogs git tree, in the contrib directory.

Long-term, what I'm thinking we need to do is to steal qemu's block
device driver files (using a scheme similar to what I did with tdb),
and create a single an I/O manager function which supports qemu qcow2
volumes.  This could be used as a much more efficient way of storing
raw e2image files (since it doesn't require sparse file support as
well as supporting in-line zlib compression), and also as a much more
efficient way of supporting "undo" functionality (by storing the
original version of the file as a cow snapshot).  If we were to
implement it as an I/O manager, then we could even run fsck on virtual
filesystems used by KVM directly from the host OS (since KVM uses qemu
and therefore the qemu block device drivers as well).

If some Quarumnet^H^H^H^H^H^H^H^H^H Red Hat engineers has some free
time, that would be a great project for someone looking to get
involved in a filesystme project.  Otherwise, it's on my TODO queue,
and I'll get to it one of these days....

						- Ted
