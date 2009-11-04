From: fabian-buettner@gmx.de
Subject: Re: Corrupt superblocks
Date: Wed, 4 Nov 2009 23:07:40 +0100
Message-ID: <200911042307.40776.fabian-buettner@gmx.de>
References: <200911041939.57795.fabian-buettner@gmx.de> <200911042256.50250.fabian-buettner@gmx.de> <4AF1F94B.5020108@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49313 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932196AbZKDWHh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 17:07:37 -0500
In-Reply-To: <4AF1F94B.5020108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 04 November 2009 22:59:39 you wrote:
> Right, but:
> 
> # e2fsck /dev/a_file_that_i_made_up
> e2fsck 1.41.4 (27-Jan-2009)
> e2fsck: No such file or directory while trying to open
> /dev/a_file_that_i_made_up
> 
> The superblock could not be read or does not describe a correct ext2
> filesystem.  If the device is valid and it really contains an ext2
> filesystem (and not swap or ufs or something else), then the superblock
> is corrupt, and you might try running e2fsck with an alternate superblock:
>     e2fsck -b 8193 <device>
> 
> all that means is /dev/vg/root doesn't exist and e2fsck can't even get
> off the ground.  Note the "if the device is valid" part ...

I see.

> so it sounds like your root vg isn't getting assembled properly in your
> other situation, which is more of a block device / lvm problem than an
> ext4 problem, I think.
> 
> -Eric
> 

So maybe i did harm my fs by running e2fsck -b?
Because running fsck afterwards gave me a lot of those Group descriptor 
checksum fixing proposals?
I am surprised that e2fsck just told me that my fs is clean.

Do you have a clue why an entry in my /etc/fsab like
/dev/vg/root            /               ext4            noatime         0 0
works, while
/dev/vg/root            /               ext4            noatime         0 1
doesnt?

- fabian
