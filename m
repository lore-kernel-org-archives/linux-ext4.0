From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Big Mess
Date: Wed, 22 Jun 2011 22:35:18 -0600
Message-ID: <81344625-1157-467E-8648-7133C020363A@dilger.ca>
References: <BANLkTi=UW-khzRKkfa_vPDzwkUu2YTmRiQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Charles Taylor <taylorc@tinnov.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:19604 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1FWEfV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 00:35:21 -0400
In-Reply-To: <BANLkTi=UW-khzRKkfa_vPDzwkUu2YTmRiQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-22, at 10:11 PM, Charles Taylor wrote:
> Normally I would not be coming here for help, but I made a big mistake
> and frankly don't think any other group has sufficient kernel/ext4
> knowledge to help me.
> 
> My partition table used to look like this:
> 
> /dev/sda1     start:6144	end:10743
> /dev/sda2     start:10743	end:10946
> 
> I deleted /dev/sda1 on a live system and recreated it like so:
> 
> /dev/sda1     start:1     end:10742
> 
> And rebooted.
> 
> Please don't ask why I did that, or how it happened. It is a long
> story and was an accident.
> 
> Needless to say, it really messed things up. I booted a rescue disk
> and changed the table back to this:
> 
> /dev/sda1     start:6144	end:10742
> /dev/sda2     start:10743	end:10946
> 
> Rebooted. No luck.
> 
> fsck.ext4 can't find a valid superblock and I haven't had any luck
> finding a backup. Some things that may help:

On another system, download the e2fsprogs code and compile the "findsuper"
tool in the misc/ directory.  If you run this against the /dev/sda device
it will print out all of the ext[23] superblocks that it finds on disk
(checking every 512-byte sector offset) and prints out what it thinks are
the offset+size of the partitions that those filesystems lived on.

> * MBR partition table.
> * All changes made with fdisk.
> * I found what looks like it may be a superblock at cylinder 6144,
> head 4, sector 16, with an offline disk editor but don't know how to
> tell fsck to use it.

Note that newer fdisk might create different layouts than older versions,
depending on what options/geometry are used.  It might make more sense
to just use sector addresses instead of CHS, since this would be far
easier to align to the output of findsuper anyway.

> * Block size is 512 bytes.
> * Disk is a 90GB SSD.
> 
> So, anyone know how I can return this file system to working order?

If it is an SSD, it's possible that repartitioning it wiped the data.
Some SSDs do strange things like this in order to keep their garbage
collection under control.

Cheers, Andreas





