From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: inline_data feature
Date: Thu, 13 Feb 2014 20:11:05 +0800
Message-ID: <20140213121105.GA12521@gmail.com>
References: <loom.20140122T171340-153@post.gmane.org>
 <loom.20140209T163201-264@post.gmane.org>
 <20140210034700.GA11434@gmail.com>
 <loom.20140210T125618-759@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ian Nartowicz <claws@nartowicz.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57493 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaBMMGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2014 07:06:05 -0500
Received: by mail-pb0-f50.google.com with SMTP id rq2so10694668pbb.23
        for <linux-ext4@vger.kernel.org>; Thu, 13 Feb 2014 04:06:04 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <loom.20140210T125618-759@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 10, 2014 at 12:06:05PM +0000, Ian Nartowicz wrote:
> Zheng Liu <gnehzuil.liu <at> gmail.com> writes:
> 
> > 
> > On Sun, Feb 09, 2014 at 03:45:12PM +0000, Ian Nartowicz wrote:
> > > Ian Nartowicz <claws <at> nartowicz.co.uk> writes:
> > > 
> > > I copied the contents of /home onto the new partition.  fsck reports, and
> > > other utilities confirm, that symlinks with targets of 60 characters or
> > > longer were corrupted by the copy.  For example, a truncated symlink:
> > > All That You Can't Leave Behind.m3u -> /data/cd/U2/All That You Can't Leave
> > > Behind/playlist.flac.m
> > > 
> > > If I create the same symlink with ln, it appears OK until I unmount and
> > > mount the partition, then it shows truncated.  fsck doesn't like it but is
> > > unable to correct it.
> > 
> > That would be great if you can provide some steps to reproduce this
> > issue.  I write a simple script to try to reproduce it, but I couldn't
> > hit the problem.  Am I missing something?
> > 
> >   #!/bin/bash
> > 
> >   mkdir test
> >   cd test
> >   filename="ALL-That-You-Can't-Leave-Behind.m3u"
> > 
> >   echo "hello" > $filename
> >   ln -s $filename symlinkfile
> >   readlink symlinkfile
> > 
> >   newdir="data/cd"
> >   mkdir -p $newdir
> >   cp -d symlinkfile $newdir
> >   readlink $newdir/symlinkfile
> > 
> > Thanks,
> >                                                 - Zheng
> > --
> 
> To reproduce this on my system, the full path for $filename needs to be
> longer than 60 characters.  That seems to be the only requirement.  Create
> the symlink, unmount, mount, and the target path of the synlink is truncated
> to 59 characters and hence the link is broken.
> 
> fsck reports those symlinks as follows:
> Symlink /iann/test.m3u (inode #139) is invalid.
> Clear<y>? no
> Entry 'test.m3u' in /iann (8001) has an incorrect filetype (was 7, should be 0).
> Fix<y>? no
> 
> If I try to clear or fix, it just leaves behind damaged inodes which fsck
> can't fix.

I believe that this patch can fix the bug that corrupts the fast
symlink [1].  Meanwhile e2fsck should fix this issue but it doesn't.  So
there is a bug in e2fsprogs.  I will try to fix it soon.

1. http://permalink.gmane.org/gmane.comp.file-systems.ext4/42518

Thanks,
                                                - Zheng
