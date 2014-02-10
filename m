From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: inline_data feature
Date: Mon, 10 Feb 2014 11:47:00 +0800
Message-ID: <20140210034700.GA11434@gmail.com>
References: <loom.20140122T171340-153@post.gmane.org>
 <loom.20140209T163201-264@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ian Nartowicz <claws@nartowicz.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46802 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaBJDmE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Feb 2014 22:42:04 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so5573012pde.0
        for <linux-ext4@vger.kernel.org>; Sun, 09 Feb 2014 19:42:04 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <loom.20140209T163201-264@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 09, 2014 at 03:45:12PM +0000, Ian Nartowicz wrote:
> Ian Nartowicz <claws <at> nartowicz.co.uk> writes:
> 
> > 
> > I have been trying to test the inline_data feature of EXT4.  I am using
> > kernel 3.9.5 and have compiled e2fsprogs from the pu branch.  I am able to
> > set the feature and apparently to use the filesystem, but I get a lot of
> > warnings from the kernel and fsck reports several errors and then crashes.
> > 
> > Typical kernel warnings from dmesg:
> > EXT4-fs warning (device sda10): ext4_rmdir:2714: empty directory has too
> > many links (9)
> > EXT4-fs error (device sda10): empty_inline_dir:1650: inode #26263: block
> > 1924: comm pool: bad entry in directory: directory entry across range -
> > offset=40(40), inode=26270, rec_len=8020, name_len=2
> > EXT4-fs warning (device sda10): empty_inline_dir:1657: bad inline directory
> > (dir #26263) - inode 26270, rec_len 8020, name_len 2inline size 60
> > 
> > Data does appear to be correctly written and read from the filesystem
> > without corruption.  Small directories appear with size 60 bytes or 132
> > bytes rather than 4.1kB so everything seems to work.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo <at> vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> I have built with the latest patchset and fsck is now a happy bunny, at
> least on my first pass.

I'd appreciate your testing.

> 
> However there is a different problem, possibly not with fsck.  For my tests
> I copied the contents of /home onto the new partition.  fsck reports, and
> other utilities confirm, that symlinks with targets of 60 characters or
> longer were corrupted by the copy.  For example, a truncated symlink:
> All That You Can't Leave Behind.m3u -> /data/cd/U2/All That You Can't Leave
> Behind/playlist.flac.m
> 
> If I create the same symlink with ln, it appears OK until I unmount and
> mount the partition, then it shows truncated.  fsck doesn't like it but is
> unable to correct it.

That would be great if you can provide some steps to reproduce this
issue.  I write a simple script to try to reproduce it, but I couldn't
hit the problem.  Am I missing something?

  #!/bin/bash
  
  mkdir test
  cd test
  filename="ALL-That-You-Can't-Leave-Behind.m3u"
  
  echo "hello" > $filename
  ln -s $filename symlinkfile
  readlink symlinkfile
  
  newdir="data/cd"
  mkdir -p $newdir
  cp -d symlinkfile $newdir
  readlink $newdir/symlinkfile
  
Thanks,
                                                - Zheng
