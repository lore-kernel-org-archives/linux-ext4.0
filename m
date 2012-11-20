From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4 speedup by storing metadata and data on separate devices
Date: Tue, 20 Nov 2012 13:56:41 -0700
Message-ID: <2A740265-42DD-4FA4-8D10-327E9177F6F4@dilger.ca>
References: <50AB63B4.1050506@icdsoft.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ivan Zahariev <famzah@icdsoft.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail111c7-2520.megamailservers.com ([69.49.98.21]:48712 "EHLO
	mail111c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752747Ab2KTU4a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 15:56:30 -0500
In-Reply-To: <50AB63B4.1050506@icdsoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-20, at 4:04, Ivan Zahariev <famzah@icdsoft.com> wrote:
> 
> This suggestion is not about storing the journal on a separate device.
> 
> Many of the tasks on an Ext4 file-system require a full or massive scan of the metadata. A few examples:
> - backup: you need to get a list with all "mtime" or "size" changed files since last backup
> - reporting: you need to get a list with all files of a particular "group" owner ID
> - delete: deleting the "/home/$user" of someone with lots of data and files
> 
> I know many efforts have been made to make the (meta)data operations "local" -- this speeds up spinning disks operations a lot, also SSD ones. However, having the whole metadata on an SSD disk (or a RAID1 of two such disks) could speed up many common tasks a lot. And the hardware price for such a benefit is really affordable now.
> 
> I see two possible implementations:
> 
> 1. Re-work the Ext4 metadata operations (that work with inodes, etc) to read/write on a separate block device.
> 
> or
> 
> 2. Add an option to the "data locality" algorithm to force it to store all metadata only at the beginning of a device (we can pre-allocate enough space). We can then transparently map in the DM those blocks to a separate faster block device, thus making the changes to Ext4 minimal.
> 
> Does all this make sense, or I'm missing something obvious?

We have implemented the #2 option using LVM with a script to map the first 128MB of the logical volume to SSD (RAID-1) and the next 255 * 128MB to HDD (usually RAID-6).  This repeats as long as there is HDD and SSD space remaining. This is done easily using lvextend in a script. 

For mke2fs, specifying a flex_bg factor of "-G 256", and limiting the inode ratio ("-n 69905", for an average file size just over 64kB) allows all of the block bitmaps and inode tables to fit into the first 128MB of the flex group with some space to spare.  This means all of the static metadata is allocated on SSD, and the directory allocations are also biased toward the remaining space in the first flex_bg group.

It isn't elegant, but it works with minimal complexity.

There was also a discussion about implementing the #1 option, to have ext4 access multiple devices for data/metadata, but nobody has actually started to implement this.

Cheers, Andreas