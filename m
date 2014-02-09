From: Ian Nartowicz <claws@nartowicz.co.uk>
Subject: Re: =?utf-8?b?aW5saW5lX2RhdGE=?= feature
Date: Sun, 9 Feb 2014 15:45:12 +0000 (UTC)
Message-ID: <loom.20140209T163201-264@post.gmane.org>
References: <loom.20140122T171340-153@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60539 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaBIPpk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Feb 2014 10:45:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1WCWZf-0000No-Ov
	for linux-ext4@vger.kernel.org; Sun, 09 Feb 2014 16:45:39 +0100
Received: from cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com ([81.103.170.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 09 Feb 2014 16:45:39 +0100
Received: from claws by cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 09 Feb 2014 16:45:39 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ian Nartowicz <claws <at> nartowicz.co.uk> writes:

> 
> I have been trying to test the inline_data feature of EXT4.  I am using
> kernel 3.9.5 and have compiled e2fsprogs from the pu branch.  I am able to
> set the feature and apparently to use the filesystem, but I get a lot of
> warnings from the kernel and fsck reports several errors and then crashes.
> 
> Typical kernel warnings from dmesg:
> EXT4-fs warning (device sda10): ext4_rmdir:2714: empty directory has too
> many links (9)
> EXT4-fs error (device sda10): empty_inline_dir:1650: inode #26263: block
> 1924: comm pool: bad entry in directory: directory entry across range -
> offset=40(40), inode=26270, rec_len=8020, name_len=2
> EXT4-fs warning (device sda10): empty_inline_dir:1657: bad inline directory
> (dir #26263) - inode 26270, rec_len 8020, name_len 2inline size 60
> 
> Data does appear to be correctly written and read from the filesystem
> without corruption.  Small directories appear with size 60 bytes or 132
> bytes rather than 4.1kB so everything seems to work.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

I have built with the latest patchset and fsck is now a happy bunny, at
least on my first pass.

However there is a different problem, possibly not with fsck.  For my tests
I copied the contents of /home onto the new partition.  fsck reports, and
other utilities confirm, that symlinks with targets of 60 characters or
longer were corrupted by the copy.  For example, a truncated symlink:
All That You Can't Leave Behind.m3u -> /data/cd/U2/All That You Can't Leave
Behind/playlist.flac.m

If I create the same symlink with ln, it appears OK until I unmount and
mount the partition, then it shows truncated.  fsck doesn't like it but is
unable to correct it.

--ian

