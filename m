From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Does ext4 send FUA to flush disk cache
Date: Mon, 11 Apr 2011 14:44:33 -0400
Message-ID: <20110411184433.GA3682@thunk.org>
References: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
 <DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
 <BANLkTi=F9c7dU9Rpt3jy5VcRtgvDB5a37Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mark Busheman <markbusheman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42526 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1DKSog (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Apr 2011 14:44:36 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=F9c7dU9Rpt3jy5VcRtgvDB5a37Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 11, 2011 at 11:23:23AM -0700, Mark Busheman wrote:
> Thanks Ted for replying.
> 
> >> FUA doesn't cause a cache flush.
>
> Thanks for correcting. Yes FUA does not flush cache. When the FUA
> bit is set in the write command, the drive make sure that the data
> goes to platters and not to be put into its cache for latter writes.

For that particular write only; and it forces the write to go directly
to the disk, bypassing any seek-mitigation algorithms the disk might
use.  It's good if you only have a very small number of sectors
(ideally one) which you need to write to the disk.  In the case of
ext4, we want to make sure all of the data and metadata blocks sent to
disk are flushed down to the platters, so FUA isn't as useful to us,
and so we don't use it.

> >> Ext4 does send cache flush commands, or barriers, to make sure the data written to disk
> >> is flushed all the way down to the disk platters on transaction commits.
>  I have few questions on this and need help:
> a. To achieve the above, is any specific options that need to be used
> while mounting?

No, not for ext3.

> b. Are the above mentioned things done only for data=journal or for
> other modes such as
> data=ordered and writeback?

It's done for all journalling modes.

> c. Are they done for metadata, journal and data writes?

Yes; see below.

> d. Can I know what are the commands sent to the drives to do the cache
> flush commands
> or barriers? Would like to find if the drive support the commands?

We use the CACHE FLUSH or CACHE FLUSH EXT command, as appropriate for
IDE/SATA disks.  There is an equivalent command for SCSI, but in
essence it establishes a barrier; all writes sent to the disk before
the CACHE FLUSH/CACHE FLUSH EXT must be written to the disk before the
barrier returns.

When we use journaling, we send a CACHE FLUSH just before the writing
the commit block, and then we send a second CACHE FLUSH after writing
the commit block.  (I suppose we could use a FUA bit for the commit
block, which might be a slight optimization if there is any other
writes happening in parallel that don't need to be affected, but it
doubt it would make a huge difference in most cases.)

> e. Is the above true also for ext3 - I posted a similar question to
> ext3 forum and have got no
> response so far?

ext3 unfortunately defaults to barriers being disabled by default.
Some distributions, such as the enterprise distro's such as RHEL and
SLES, will enable ex3 barriers by default.  You can use the mount
option "barrier" to enable barriers at mount time with ext3, if you
want to be sure barriers are enabled.

With ext4, if you want to disable barriers for some reason (say you
are confident the system has a dead reliable UPS and you need the
performance), you can use the mount option nobarrier.  (It enables
barriers by default.)

						- Ted
