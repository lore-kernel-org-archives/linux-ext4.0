From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext3, BKL, journal replay, multiple non-bind mounts of same device
Date: Tue, 10 Apr 2007 21:56:21 -0600
Message-ID: <20070411035621.GM5967@schatzie.adilger.int>
References: <alpine.DEB.0.83.0704102041210.7971@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernelnewbies@nl.linux.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:60523 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030775AbXDKD4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Apr 2007 23:56:24 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0704102041210.7971@sigma.j-a-k-j.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 10, 2007  20:49 -0400, John Anthony Kazos Jr. wrote:
> Since it is possible for the same block device to be mounted multiple 
> times concurrently by the same filesystem, and since ext3 explicitly 
> disables the BKL during its fill_super operation which would prevent this, 
> what is the result of mounting it multiple times this way? Especially if 
> the filesystem is dirty and a journal is replayed. (In any case, what 
> operation is being performed by ext3/ext4 that requires the BKL to be 
> dropped? What's the need to even consider the BKL during fill_super?)
> 
> And in general, how does a filesystem deal with being mounted multiple 
> times in this way? In my testing and exploration so far, everything seems 
> to generally work, but I haven't tried deliberately using different 
> instances of the mount concurrently. Do we end up with locks not being 
> held properly on the superblock because the super_block structure 
> instances don't know about each other? Has dealing with this behavior of 
> bd_claim really been considered before, and if so, what's the general 
> scheme for handling it?

It is a myth (that actually frightened me quite a bit when I first did it)
that the filesystem is mounted twice in this case.  The truth of the matter
is if you "mount -t ext3 /dev/XXXX /mnt/1" and "... /mnt/2" you actually
get the equivalent of a bind mount for this block device on the two mount
points.  You can see this easily because e.g. you don't get two kjournald
threads for the two mounts, and it doesn't completely blow up.

If, on the other hand, you tried one mount with ext3 and another with ext4
it will fail the second with -EBUSY.

As for the BKL changes, your best bet is to go back through GIT and/or BK
or search the mailing lists to see when and why that was added.  It appears
to have  been 2.6.11, but I don't know why.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
