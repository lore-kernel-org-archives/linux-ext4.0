From: Ted Ts'o <tytso@mit.edu>
Subject: Re: What to put for unknown stripe-width?
Date: Tue, 20 Sep 2011 12:00:34 -0400
Message-ID: <20110920160034.GD13772@thunk.org>
References: <4E786B53.5020407@shiftmail.org>
 <9D3B900A-8FCF-41B1-852A-FADD953FBDBD@mit.edu>
 <4E78B15E.9060702@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59139 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1ITQAi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Sep 2011 12:00:38 -0400
Content-Disposition: inline
In-Reply-To: <4E78B15E.9060702@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 20, 2011 at 05:29:34PM +0200, torn5 wrote:
> 
> No this is not correct, for MD at least.
> MD uses strips to compute parity, which are always 4k wide for each
> device. The reads in your example would be 32k read from two
> devices, followed by 32k write to two devices.

Then where the heck are these 1MB numbers that you cited originally
coming from?  If by that you mean the LVM PE size, that doesn't matter
to the file system.  It matters as far as your efficiency of doing LVM
snapshots, but what matters from the perspective of the file system's
stripe-width (stride doesn't really matter with the ext4 flex_bg
layout) is the RAID parameters at the MD level, NOT the LVM
parameters.  (This is assuming LVM is properly aligning its PE's with
the RAID stripe sizes, but I'll assume for the purposes of this
discussion that LVM is competently implemented...)

> So, regarding my original problem, the way you use stride-size in
> ext4 is that you begin every new file at the start of a stripe?

The design goal (not completely implemented at the moment) is that
block allocation will try (but may not succeed if the free space is
fragmented, etc.) to align files to begin at the start of a stripe,
and that file writes will be try to avoid RAID 5 read/modify/write
cycles.

> For growing an existing file what do you do, do you continue to
> write it from where it was, without holes, or you put a hole, select
> a new location at the start of a new stripe and start from there?

We will try to arrange things so that subsequent reads and writes are
well aligned.  So the assumption here is that the application will
also be intelligent enough to do the right thing.  (i.e., if you have
a 32k stripe width, writes need to be 32k aligned and in multiples of
32k at the logical block layer, which the file system will translate
into appropriately aligned reads and writes to the RAID array.)

> Regarding multiple very small files wrote together by pdflush, what
> do they do? They are sticked together on the same stripe without
> holes, or each one goes to a different stripe?

pdflush has no idea about RAID, so for small files it's all up in the
air.

> Is the change of stripe-width with tune2fs supported on a live,
> mounted fs? (I mean maybe with a mount -o remount but no umount)

It's supported, but it's not going to change the layout of the live,
mounted file system.

I'm going to strongly caution you about using fancy-shmancy features
like this MD reshape.  You yourself have said it's not stable.  But do
you really need it?  You haven't said what your application is, but it
may be much better to simply add new disks in multiples of your
existing stripe width, and just keep things simple.

Also, why are you using RAID?  Is it for reliability, or performance,
or both?  Have you seen some of the recent (well, in the last 4-5
years paper about relibility of disks and RAID)?  Especially
interesting comments such as

    "Protecting online data only via RAID 5 today verges on
    professional malpractice"

http://storagemojo.com/2007/02/26/netapp-weighs-in-on-disks/

Regards,

					- Ted
