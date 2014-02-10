From: Ian Nartowicz <claws@nartowicz.co.uk>
Subject: Re: =?utf-8?b?aW5saW5lX2RhdGE=?= feature
Date: Mon, 10 Feb 2014 12:06:05 +0000 (UTC)
Message-ID: <loom.20140210T125618-759@post.gmane.org>
References: <loom.20140122T171340-153@post.gmane.org> <loom.20140209T163201-264@post.gmane.org> <20140210034700.GA11434@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39054 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaBJMGf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Feb 2014 07:06:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1WCpdA-00057Q-Fi
	for linux-ext4@vger.kernel.org; Mon, 10 Feb 2014 13:06:32 +0100
Received: from cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com ([81.103.170.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 10 Feb 2014 13:06:32 +0100
Received: from claws by cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 10 Feb 2014 13:06:32 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zheng Liu <gnehzuil.liu <at> gmail.com> writes:

> 
> On Sun, Feb 09, 2014 at 03:45:12PM +0000, Ian Nartowicz wrote:
> > Ian Nartowicz <claws <at> nartowicz.co.uk> writes:
> > 
> > I copied the contents of /home onto the new partition.  fsck reports, and
> > other utilities confirm, that symlinks with targets of 60 characters or
> > longer were corrupted by the copy.  For example, a truncated symlink:
> > All That You Can't Leave Behind.m3u -> /data/cd/U2/All That You Can't Leave
> > Behind/playlist.flac.m
> > 
> > If I create the same symlink with ln, it appears OK until I unmount and
> > mount the partition, then it shows truncated.  fsck doesn't like it but is
> > unable to correct it.
> 
> That would be great if you can provide some steps to reproduce this
> issue.  I write a simple script to try to reproduce it, but I couldn't
> hit the problem.  Am I missing something?
> 
>   #!/bin/bash
> 
>   mkdir test
>   cd test
>   filename="ALL-That-You-Can't-Leave-Behind.m3u"
> 
>   echo "hello" > $filename
>   ln -s $filename symlinkfile
>   readlink symlinkfile
> 
>   newdir="data/cd"
>   mkdir -p $newdir
>   cp -d symlinkfile $newdir
>   readlink $newdir/symlinkfile
> 
> Thanks,
>                                                 - Zheng
> --

To reproduce this on my system, the full path for $filename needs to be
longer than 60 characters.  That seems to be the only requirement.  Create
the symlink, unmount, mount, and the target path of the synlink is truncated
to 59 characters and hence the link is broken.

fsck reports those symlinks as follows:
Symlink /iann/test.m3u (inode #139) is invalid.
Clear<y>? no
Entry 'test.m3u' in /iann (8001) has an incorrect filetype (was 7, should be 0).
Fix<y>? no

If I try to clear or fix, it just leaves behind damaged inodes which fsck
can't fix.

--ian

