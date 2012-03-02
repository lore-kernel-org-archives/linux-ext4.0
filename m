From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Some interesting input from a flash manufacturer
Date: Fri, 2 Mar 2012 18:11:31 -0500
Message-ID: <20120302231131.GE22215@thunk.org>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
 <4F5135F0.6090100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57867 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab2CBXLi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 18:11:38 -0500
Content-Disposition: inline
In-Reply-To: <4F5135F0.6090100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 02, 2012 at 03:04:48PM -0600, Eric Sandeen wrote:
> > One is that he would actually be very happy if we send lots of extra
> > trim commands; in particular, he would actually *like* us to send trims
> > at unlink/commit time, *and* trims periodically via FITRIM.  The reason
> > for that is because that way, if the disk is busy, it would be OK if he
> > dropped the TRIM on the floor, knowing that he would get another bite at
> > the apple later on.  But, if the disk has time to process the trim, he
> > he would be able to use that information as quickly as possible.
> 
> Is that within spec?

Yup; the drive manufacturer is free to do anything they want with the
TRIM command; it's purely advisory.  So dropping it on the floor if
you're too busy because some other process is sending random 4k writes
to you at a high rate, is something that's within spec.

Or if the thin provisioning service is only tracking blocks with a
granularity of 4megs, and it receives trim request for less than 4
megabytes, it again is perfectly free to drop the trim request on the
floor.  I'm even aware of one implementation which remembers the trim
request while the system is powered on, but since it doesn't
(necessarily) write the trim information to stable store, you could
trim the block, read the block and get zeros, then take a power
failure, and afterwards, read the block and get the previous contents.

As far as I know, the Trim spec allows all of this.

> > We also talked about ways that we might right some application notes so
> > that handset OEM's understood how to use mke2fs parameters to optimize
> > their file systems for different types of flash systems, and perhaps
> > ways that the eMMC spec could be enhanced so that key parameters such as
> > erase block size, flash page size, and translation table granularity
> > could be passed back to the block layer, and made available to file
> > system and mkfs.
> 
> Now that would be nice.  Could some of this just be piggybacked on the
> existing preferred_io_size-type geometry interfaces?  

As far as the /sys/block/XXX/queue/* framework, certainly.  It's not
clear, however, whether or not we should use entirely new parameters,
or try to reuse the existing parameters.  For example, would it be
better to use optimal_io_size for the flash page size, or the erase
block size?

						- Ted
