From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: ext4 bug and/or e2fsck hole
Date: Wed, 8 Apr 2009 14:13:58 +0930
Message-ID: <20090408044357.GH4328@kulgan>
References: <20090407204811.GA4495@kulgan> <20090407231324.GF3204@webber.adilger.int> <20090407233955.GA4328@kulgan> <20090407235835.GI3204@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:50029 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZDHEoA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2009 00:44:00 -0400
Content-Disposition: inline
In-Reply-To: <20090407235835.GI3204@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07, 2009 at 04:58:35PM -0700, Andreas Dilger wrote:
> On Apr 08, 2009  09:09 +0930, Kevin Shanahan wrote:
> > hermes:~# debugfs -c -R 'imap 383' /dev/dm-0
> > debugfs 1.41.3 (12-Oct-2008)
> > /dev/dm-0: catastrophic mode - not reading inode or group bitmaps
> > 383: File not found by ext2_lookup 
> > hermes:~# debugfs -c -R 'imap <383>' /dev/dm-0
> > debugfs 1.41.3 (12-Oct-2008)
> > /dev/dm-0: catastrophic mode - not reading inode or group bitmaps
> > Inode 383 is part of block group 0
> >         located at block 312, offset 0x0e00
> 
> In the meantime you can use "debugfs -w /dev/dm-0", "clri {filename}"
> to zero out the inode, "freei {filename}" to mark the inode unused,
> and "rm {filename}" to remove the file from the directory.

Thanks, I'll do this tonight when I can unmount the filesystem
again. If you think of anything other information I should gather
before I do that, let me know in the next 6-7 hours ;)

Cheers,
Kevin.
