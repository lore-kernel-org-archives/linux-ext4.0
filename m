From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: breaking ext4 to test recovery
Date: Thu, 31 Mar 2011 12:21:46 -1000
Message-ID: <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:52471 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1CaWVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2011 18:21:52 -0400
In-Reply-To: <4D91E39A.3000800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-29, at 3:50 AM, Eric Sandeen wrote:
> On 3/28/11 9:45 PM, Daniel Taylor wrote:
>> I would like to be able to break our ext4 file system
>> (specifically corrupt the journal) to be sure that we
>> can automatically notice the problem and attempt an
>> autonomous fix.
>> 
>> dumpe2fs tells me the inode, but not, that I can see, the
>> blocks where the journal exists (for "dd"ing junk to it).
>> 
>> Is there any debug tool that would let me deliberately
>> break the file system (at least, trash the journal)?
>> 
>> If not, is there a hint for figuring out the block(s) of
>> the journal so I can stomp it?
>> 
>> The kernel is in an embedded machine, so it's a little old
>> 2.6.32.11 and e2fsprogs/libs 1.41.12-2 (Lenny)
> 
> But are you trying to test in-kernel recovery, or e2fsck, after
> you corrupt the journal?  Or both?
> 
> I assume you'd start with a filesystem with a dirty log,
> corrupt that log, and then what, fsck it, or try to mount it?
> 
> How are you generating your fs w/ dirty log?
> 
> (xfs has an ioctl to abruptly "stop" the fs as if it had crashed,
> that would be very useful in extN as well).

We have a kernel patch "dev_read_only" that we use with Lustre to disable writes to the block device while the device is in use.  This allows simulating crashes at arbitrary points in the code or test scripts.  It was based on Andrew Morton's test harness that he used for ext3 recovery testing back when it was being ported to the 2.4 kernel.

http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob_plain;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch;hb=HEAD

The best part of this patch is that it works with any block device, can simulate power failure w/o any need for automated power control, and once the block device is unused (all buffers and references dropped) it can be re-activated safely.

> Another thing which could use lots more testing in the wild is
> simple journal recovery; nothing is corrupted, but the drive got
> unplugged or the system lost power while the fs was under load;
> see if a mount; umount; fsck and/or if a fsck; mount; umount; fsck finds
> errors.
> 
> (the former will test in-kernel log recovery, the latter will test
> log recovery in e2fsck).

Cheers, Andreas





