From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Thu, 10 Sep 2009 03:11:11 +0200
Message-ID: <20090910011111.GB1981@phenom2.trippelsdorf.de>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de>
 <4AA7BE69.7070406@redhat.com>
 <20090909172015.GA1980@phenom2.trippelsdorf.de>
 <4AA7E411.7070005@redhat.com>
 <20090909212925.GA2011@phenom2.trippelsdorf.de>
 <4AA81FB1.7000000@redhat.com>
 <20090909214223.GB2011@phenom2.trippelsdorf.de>
 <4AA82224.3010605@redhat.com>
 <20090909215055.GC2011@phenom2.trippelsdorf.de>
 <4AA82C62.40305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-144.synserver.de ([212.40.180.144]:1036 "HELO
	smtp-out-144.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751448AbZIJBLK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 21:11:10 -0400
Content-Disposition: inline
In-Reply-To: <4AA82C62.40305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 05:29:54PM -0500, Eric Sandeen wrote:
> Markus Trippelsdorf wrote:
> > On Wed, Sep 09, 2009 at 04:46:12PM -0500, Eric Sandeen wrote:
> >> Markus Trippelsdorf wrote:
> >>> On Wed, Sep 09, 2009 at 04:35:45PM -0500, Eric Sandeen wrote:
> >> ...
> >>
> >>>> Just for completeness, if there are errors in the system logs, can you 
> >>>> post them here as well?
> >>> There are no errors in the system logs.
> >>> I only learned about this bug when a regular boot-time fsck was running that
> >>> printed the problems mentionted above.
> >> Hm, but there should be no regular boot-time fsck unless you have your 
> >> forced-fsck interval set pretty low; a normal boot-time fsck will simply 
> >> replay the log.  Was that it; did you just happen to catch this on the 
> >> 21st boot or whatever the interval may be?
> > 
> > Yes, sorry I didn't make myself clear, I just happen to catch this on
> > the 21st boot...
> > After that I booted from an USB stick and ran fsck by hand from there.
> 
> Are you certain there are no errors logged?  The fs -is- flagged with 
> errors:
> 
> # file disc_e2image
> disc_e2image: Linux rev 1.0 ext4 filesystem data (needs journal 
> recovery) (errors) (extents) (large files) (huge files)
> 
> At what point did you make that image?

I did the cp -al; after that I ran "tune2fs -C 99 /dev/sda1" to force a
e2fsck -p at next boot. I rebooted, the fs became marked with errors by
e2fsck -p. Then I ran "e2image -r /dev/sda1 - | bzip2 > disc_e2image.bz2"
on the mounted fs.

BTW the image shows the errors nicely:

 # fsck.ext4 -n disc_e2image
e2fsck 1.41.9 (22-Aug-2009)
Warning: skipping journal recovery because doing a read-only filesystem check.
disc_e2image contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Problem in HTREE directory inode 2409285: node (1) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (1) has bad max hash
Problem in HTREE directory inode 2409285: node (1) not referenced
Problem in HTREE directory inode 2409285: node (2) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (2) has bad max hash
Problem in HTREE directory inode 2409285: node (2) not referenced
Problem in HTREE directory inode 2409285: node (3) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (3) has bad max hash
Problem in HTREE directory inode 2409285: node (3) not referenced
Problem in HTREE directory inode 2409285: node (4) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (4) has bad max hash
Problem in HTREE directory inode 2409285: node (4) not referenced
Problem in HTREE directory inode 2409285: node (5) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (5) has bad max hash
Problem in HTREE directory inode 2409285: node (5) not referenced
Problem in HTREE directory inode 2409285: node (6) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (6) has bad max hash
Problem in HTREE directory inode 2409285: node (6) not referenced
Problem in HTREE directory inode 2409285: node (7) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (7) has bad max hash
Problem in HTREE directory inode 2409285: node (7) not referenced
Problem in HTREE directory inode 2409285: node (8) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (8) has bad max hash
Problem in HTREE directory inode 2409285: node (8) not referenced
.
.
.
Problem in HTREE directory inode 2409285: node (1026) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (1026) has bad max hash
Problem in HTREE directory inode 2409285: node (1026) not referenced
Problem in HTREE directory inode 2409285: node (1027) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (1027) has bad max hash
Problem in HTREE directory inode 2409285: node (1027) not referenced
Problem in HTREE directory inode 2409285: node (1028) has invalid depth (2)
Problem in HTREE directory inode 2409285: node (1028) has bad max hash
Problem in HTREE directory inode 2409285: node (1028) not referenced
Invalid HTREE directory inode 2409285 (/backup/hourly.2/localhost/home/markus/.maildir/lkml/cur).  Clear HTree index? no

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (18497534, counted=18497453).
Fix? no


disc_e2image: ********** WARNING: Filesystem still has errors **********

disc_e2image: 809496/6545408 files (0.3% non-contiguous), 7668326/26165860 blocks
-- 
Markus
