From: Charles Cazabon <charlesc-linux-ext4@pyropus.ca>
Subject: Delayed block allocation failures after shrinking fs
Date: Sat, 19 Jul 2014 16:39:06 -0600
Message-ID: <20140719223906.GA8148@pyropus.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:54369 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751137AbaGSWqZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jul 2014 18:46:25 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greetings,

I ran into some odd behaviour/problems with an ext4 filesystem recently, and
it appears I ran into an ext4 problem.  I've recovered my data, but wanted to
know if the developers want any info about this problem before I wipe it out.

I had a ~5TB ext4 filesystem (on LVM, on LUKS encrypted partitions, on
spinning disks) that I had migrated much of the data off of, and planned to
replace the underlying disks with a much smaller but faster SSD setup.

So I unmounted the filesystem, fsck'ed it, shrank it to ~300GB with `resize2fs
-M, then shrank the size of the LVM logical volume it was sitting on (to
~320G), then migrated the data off the spinning disks and to the SSD by
migrating the LVM extents.  After this, I started seeing `Delayed block
allocation failed` errors for this filesystem, and indeed some files were
getting corrupted as they were written to.  My first suspicion was that this
was due to a faulty SSD, but that doesn't appear to be the case -- for one
thing, there were no SATA or other errors for the device logged.

I tested the SSD by setting up another filesystem on it, and letting mkfs.ext4
run badblocks over it -- no errors were reported.  Running various filesystem
benchmarks and testing programs on the test filesystem showed no problems
either, so I created a new ext4 filesystem, copied the data over from the
failing filesystem, and switched to using it -- and the problems went away
entirely (this is with the new filesystem on the same underlying physical
device as the problematic one).  I've run like this for several days now, and
have had no EXT4 errors (or other errors) logged about the new filesystem, and
have experienced no further data corruption.

So it would appear the filesystem didn't survive the shrink operation entirely
fine.  I've recovered my data from backups, so this is not a big deal, but I
was wondering if the ext4 developers would like any information (metadata
image or whatever else) from this filesystem before I wipe it and reuse the
space.  Shrinking a formerly-full filesystem from several TB to a few hundred
GB is probably not a case that gets tested a lot, I would guess.

I'm not subscribed to the list, so would appreciate a cc: on responses.

Thanks,

Charles
-- 
------------------------------------------------------------------
Charles Cazabon                   <charlesc-linux-ext4@pyropus.ca>
Software, consulting, and services available at http://pyropus.ca/
------------------------------------------------------------------
