From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4 external journal UUID mismatch?
Date: Mon, 16 Jul 2012 08:13:20 -0600
Message-ID: <06122409-66B8-41E0-84D3-AE449A0AE908@dilger.ca>
References: <20120715234058.GA2562@tuon.disenchant.local> <20120716025610.GB2562@tuon.disenchant.local> <11FEA6E4-EF75-4CD9-B2B6-78E42410027B@gmail.com> <20120716100010.GC2562@tuon.disenchant.local>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Kevin Shanahan <kmshanah@disenchant.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail119c7.megamailservers.com ([69.49.98.219]:39726 "EHLO
	mail119c7.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab2GPOqZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 10:46:25 -0400
In-Reply-To: <20120716100010.GC2562@tuon.disenchant.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-16, at 4:00, Kevin Shanahan <kmshanah@disenchant.net> wrote:

> On Sun, Jul 15, 2012 at 10:32:01PM -0600, Andreas Dilger wrote:
>> 
>> 
>> Because LVM changed the block device numbers after the reboot, and
>> the device number used previously for the external journal was
>> different.
>> 
>> The lookup of the journal by UUID (instead of relying on the "device
>> hint" in the superblock) _should_ be handled by mount, but I don't
>> recall if we ever got a mount.ext4 to handle this or not. It would
>> also be possible for the "fast e2fsck" check to verify the journal
>> UUID before mounting the filesystem, but again I'm not sure if this
>> is done yet, and I can't check right now.
> 
> Ok, thanks. For now I can ask LVM to make the major/minor number
> persistent.
> 
> Assuming it's not already done, do you think adding the UUID lookup
> would be a reasonable project for a newbie or is it likely to be a bit
> complicated?

It should be fairly easy. During e2fsck checking of the superblock, it should check if there is an external journal, and then call into libblkid to find the journal UUID and verify the block device matches the value stored in the superblock. 

> I'm assuming support is not there, at least for the versions in Arch:
> 
> $ pacman -Q e2fsprogs util-linux
> e2fsprogs 1.42.4-1
> util-linux 2.21.2-5

This is the latest version of e2fsprogs. 

Cheers, Andreas