From: Andreas Dilger <adilger@sun.com>
Subject: Re: file allocation problem
Date: Fri, 17 Jul 2009 17:14:44 -0400
Message-ID: <20090717211444.GF4231@webber.adilger.int>
References: <200907161331.17623.coolo@suse.de>
 <200907170717.12225.coolo@suse.de> <20090717142628.GL8508@mit.edu>
 <200907172002.19286.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Stephan Kulow <coolo@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44210 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352AbZGQVO4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 17:14:56 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6HLEqlb012141
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 14:14:52 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMY00B002SXHU00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 17 Jul 2009 14:14:52 -0700 (PDT)
In-reply-to: <200907172002.19286.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 17, 2009  20:02 +0200, Stephan Kulow wrote:
> On Friday 17 July 2009 16:26:28 Theodore Tso wrote:
> > And this isn't necessarily going to help; if 16 block groups around
> > (2**4) for the flex_bg for the /usr/bin directory are all badly
> > fragmented, then when you create new files in /usr/bin, it will still
> > be fragmented.
>
> Yeah, but even the file in /tmp/nd got 3 extents. my file is 1142 blocks
> and my mb_groups says 2**9 is the highest possible value. So I guess I will
> indeed try to create the file system from scratch to test the allocator for 
> real.

The defrag code needs to become smarter, so that it finds small files 
in the middle of freespace and migrates those to fit into a small gap.
That will allow larger files to be defragged once there is large chunks
of free space.

> > allocator tries to keep files aligned on power of two boundaries,
> > which tends to help this a lot (although this means that dumpe2fs -h
> > will show a bunch of holes that makes the free space look more
> > fragmented than it really is), but the ext3 allocator doesn't have any
> > such smarts on it.
> But there is nothing packing the blocks if the groups get full, so these
> holes will always cause fragmentation once the file system gets full, right?
 

Well, this isn't quite correct.  The mballoc code only tries to allocate
"large" files on power-of-two boundaries, where large is 64kB by default,
but is tunable in /proc.  For smaller files it tries to pack them together
into the same block, or into gaps that are exactly the size of the file.

> So I guess online defragmentation first needs to pretend doing an online 
> resize so it can use the gained free size. Now I have something to test.. :)

Yes, that would give you some good free space at the end of the filesystem.
Then find the largest files in the filesystem, migrate them there, then
defrag the smaller files.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

