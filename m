From: Stephan Kulow <coolo@suse.de>
Subject: Re: file allocation problem
Date: Thu, 16 Jul 2009 19:43:21 +0200
Message-ID: <200907161943.21575.coolo@suse.de>
References: <200907161331.17623.coolo@suse.de> <20090716155832.GA6605@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:37134 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932795AbZGPRnZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2009 13:43:25 -0400
In-Reply-To: <20090716155832.GA6605@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 16 July 2009 17:58:32 Theodore Tso wrote:
> On Thu, Jul 16, 2009 at 01:31:17PM +0200, Stephan Kulow wrote:
> > Hi,
> >
> > I played around with ext4 online defrag on 2.6.31-rc3 and noticed a
> > problem. The core is this:
>
> Was your filesystem originally an ext3 filesystme which was converted
> over to ext4?  What features are currently enabled (sending a copy of
Yes, it was converted quite some time ago.

> the output of "dumpe2fs -h /dev/XXX" would be helpful.)

Filesystem volume name:   <none>
Last mounted on:          /root
Filesystem UUID:          ec4454af-a8db-42ad-9627-19c9c17a0220
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype 
needs_recovery extent sparse_super large_file
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              853440
Block count:              3409788
Reserved block count:     170489
Free blocks:              1156411
Free inodes:              615319
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      832
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8128
Inode blocks per group:   508
Filesystem created:       Fri Dec 12 17:01:57 2008
Last mount time:          Thu Jul 16 19:30:26 2009
Last write time:          Thu Jul 16 19:30:26 2009
Mount count:              718
Maximum mount count:      -1
Last checked:             Thu Jan 29 15:01:57 2009
Check interval:           0 (<none>)
Lifetime writes:          5211 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       650850
Default directory hash:   half_md4
Directory Hash Seed:      a262693d-9659-4212-8e5b-5901140edff8
Journal backup:           inode blocks
Journal size:             128M

>
> If it is the case that this was originally an ext3 filesystem,
> e4defrag does have some definite limitations that will prevent it from
> doing a great job in such a case.  I'm guessing that's what's going on
> here.
My problem is not so much with what e4defrag does, but the fact that
a new file I create with cp(1) contains 34 extents.

>
> > Now that I call fragmented! Calling e4defrag again gives me
> > 34->28 and now it moved _parts_
>
> I'm not sure what you mean by moving _parts_?
It moved a couple of blocks from 6XXX to 10XXX and most extents stayed in the 
area where they were (I guess close to the rest of /usr/bin?)

Greetings, Stephan
