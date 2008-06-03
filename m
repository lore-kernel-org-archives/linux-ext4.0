From: Andreas Dilger <adilger@sun.com>
Subject: Re: Questions for article
Date: Tue, 03 Jun 2008 16:07:10 -0600
Message-ID: <20080603220710.GM2961@webber.adilger.int>
References: <27337.143.166.226.57.1212443437.squirrel@tomslinux.homelinux.org>
 <20080602225942.GQ2961@webber.adilger.int>
 <61365.143.166.255.40.1212505833.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Thomas King <kingttx@tomslinux.homelinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35489 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYFCWHN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 18:07:13 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m53M7Cci002177
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 15:07:12 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1W00G01QM6Z000@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 03 Jun 2008 15:07:12 -0700 (PDT)
In-reply-to: <61365.143.166.255.40.1212505833.squirrel@tomslinux.homelinux.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 03, 2008  10:10 -0500, Thomas King wrote:
> > The mballoc code also does efficient block allocations (multi-MB at a
> > time), BUT there is no userspace interface for this yet, except O_DIRECT.
> > The delayed allocation (delalloc) patches for ext4 are still in the unstable
> > part of the patch series...  What Henry is misunderstanding here is that
> > the filesystem blocksize isn't necessarily the maximum unit for space
> > allocation.  I agree we could do this more efficiently (e.g. allocate an
> > entire 128MB block group at a time for large files), but we haven't gotten
> > there yet.
>
> Can I assume this (large block size) is a possibility later?

Well, anything is a possibility later.  There are no plans to implement it.

> > I'd personally tend to keep quiet until we CAN show that ext4
> > runs well on a 100TB filesystem, that e2fsck time isn't fatal, etc.
>
> What will be the largest theoretical filesystem for ext4?

In theory, it could be 2^64 bytes in size, though common architectures
would currently be limited to 2^60 bytes due to 4kB PAGE_SIZE == blocksize.
I'm not at all interested in "theoretical filesystem size", however, since
theory != practise and a 2^64-byte filesystem that takes 10 weeks to format
or fsck wouldn't be very useful...  Not that I think ext4 is that bad, but
I don't like to make claims based on complete guesswork.

> Here are three other features he thought necessary for massive filesystems in
> Linux:
> -T10 DIF (block protect?) aware file system

- DIF support is underway, though I'm not aware of filesystem support for it

> -NFSv4.1 support

- in progress

> -Support for proposed POSIX relaxation extensions for HPC

- nothing more than a proposal, it wouldn't even begin to see Linux
  implementation until there is something more than a few emails on
  the list.  These are mostly meaningless outside of the context of
  a cluster.

Don't get me wrong, these ARE things that Linux will want to implement
as filesystems and clusters get huge, and it is also my job to work on
such large file system deployments.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

