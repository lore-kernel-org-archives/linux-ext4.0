From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs] resizing to minimum was failed since 45a78b
Date: Thu, 30 Apr 2015 11:13:16 -0400
Message-ID: <20150430151316.GF12374@thunk.org>
References: <01cb01d08257$26157350$724059f0$@samsung.com>
 <20150429142912.GA18756@thunk.org>
 <012401d0832e$1b353330$519f9990$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org
To: Chanho Park <chanho61.park@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37802 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbbD3PNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Apr 2015 11:13:18 -0400
Content-Disposition: inline
In-Reply-To: <012401d0832e$1b353330$519f9990$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 30, 2015 at 07:12:04PM +0900, Chanho Park wrote:
> 
> In my situation, I usually use the "resize2fs -M" when making a tizen
> platform image. As you know, like android, tizen also uses ext4 filesystem
> and flash the image from bootloader. Instead of flashing full image size, we
> only flash shrinked filesystem image to reduce flashing time and want to
> avoid download huge files. If the partition size is 3GB, we'll make a 3GB
> loop image and fill files into it. And I shrink the loop image to the
> minimum size and flash it to my phone. When first booting, the system will
> do resizing the partition to 3GB original size.

What I would recommend is to estimate how big the file system needs to
doing a "du -s" over the directory that you want to preload onto the
file system size, add say, 5% or so the file system metadata, and then
create the file system that way.  If the file system is close enough
to the right size, then resize2fs -M is much more likely to shrink the
file system to its minimal size, and also reduce the file
fragmentation that results from it.  (One of the better uses for using
resize2fs to slightly shrink a file system was to make room for the
LVM table at the end of the device, for example.  It's when you try to
take, say, a 1TB file system and shrink to a few megabytes that
resize2fs doesn't do a great job, because it really wasn't engineered
for that use case, and it's hard enough to make sure it does so in a
efficient and robust manner as it is.)

You can then take that file system and shrink to a size far larger
than what it was originally created as --- that works much better than
taking a large empty file system, shrinking it down to its minimal
size, and then expanding it to something bigger.  If necessary, you
can use the "mke2fs -E resize=15T" option to make sure enough metadata
blocks have been reserved so the file system can be expanded as much
as you would like.  By default we reserve enough metadata blocks for
the file system to grow by a factor of a thousand, so if you create a
super-tiny file system and then expect to grow it to a multi-TB size,
that mke2fs option will be useful.  It's not strictly necessary for
ext4 (although it was required for ext3), but it will result in a
slightly more efficient file system that will mount more quickly under
ext4.

So if your Tizen image is, say, 390 megabytes, I'd suggest creating a
400 megabyte file system, and load that up with the image.  If you
then use resize2fs -M, it should shirnk it down to something much
closer to 390M.

I suspect you will find that the resulting image will be far more
efficient than trying to start with a 3GB file system, shrink it down
to 400M, and then expand it backup to 3GB.

Best regards,

					- Ted
