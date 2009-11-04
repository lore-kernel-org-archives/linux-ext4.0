From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Corrupt superblocks
Date: Wed, 04 Nov 2009 15:59:39 -0600
Message-ID: <4AF1F94B.5020108@redhat.com>
References: <200911041939.57795.fabian-buettner@gmx.de> <4AF1D42A.6000304@redhat.com> <200911042256.50250.fabian-buettner@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: fabian-buettner@gmx.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbZKDV7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 16:59:37 -0500
In-Reply-To: <200911042256.50250.fabian-buettner@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fabian-buettner@gmx.de wrote:
>> Why do you say you have a corrupted superblock?
> 
> Because of this message: fsck.ext4: No such file or directory while trying to 
> open /dev/vg/root
> /dev/vg/root: The superblock could not be read or does not describe a correct 
> ext2 filesystem ... at the end of this message i am told to run e2fsck -b 
> 8193 <device>

Right, but:

# e2fsck /dev/a_file_that_i_made_up
e2fsck 1.41.4 (27-Jan-2009)
e2fsck: No such file or directory while trying to open
/dev/a_file_that_i_made_up

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

all that means is /dev/vg/root doesn't exist and e2fsck can't even get
off the ground.  Note the "if the device is valid" part ...

>> I suppose I'd try booting a live/rescue cd, and just manually run e2fsck
>> against your root device, as a starter - and capture any interesting
>>  output.
>>
>> Any sort of kernel or fsck logs indicating more of what actually went
>> wrong would be Very helpful here.
> 
> I just booted into a rescue cd and run e2fsck /dev/vg/root.
> surprisingly it said: /dev/vg/root: clean

so it sounds like your root vg isn't getting assembled properly in your
other situation, which is more of a block device / lvm problem than an
ext4 problem, I think.

-Eric
