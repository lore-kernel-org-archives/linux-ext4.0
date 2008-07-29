From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: Porting Zfs features to ext2/3
Date: Tue, 29 Jul 2008 22:52:26 +0000 (UTC)
Message-ID: <loom.20080729T222131-137@post.gmane.org>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42937 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYG2Wwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 18:52:39 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KNy3Y-0005If-SI
	for linux-ext4@vger.kernel.org; Tue, 29 Jul 2008 22:52:36 +0000
Received: from 81-197-3-72.elisa-mobile.fi ([81.197.3.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 22:52:36 +0000
Received: from szaka by 81-197-3-72.elisa-mobile.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 22:52:36 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso <at> mit.edu> writes:
> On Sun, Jul 27, 2008 at 04:54:41PM -0600, Eric Anopolsky wrote:
> > On Sun, 2008-07-27 at 01:49 -0700, postrishi wrote:
> > > 
> > > I want to know that has any work been done to port the Zfs features to
> > > ext2/3
> > 
> > Did you know that ZFS is available for Linux?
> 
> ZFS is available in a FUSE filesystem.  As a userspace filesystem, it
> means a huge number of context switches to get data between the disk,
> to the kernel, to the FUSE userspace, back to the kernel, and to the
> process trying to access the ZFS file.  

Transferring 4 kB from a commodity disk (disk seek + rotational delay + 
transfer) takes usually between 100-4,000 usec. Two context switches 
take about 2 usec, i.e. only 2-0.05% of the full data transfer time. 

In other words, there isn't really time for huge number of context 
switches because most of the time is spent waiting for the disk.

> That's not going to be high performance.  

I did also an in memory test on a T9300@2.5, with disk I/O completely 
eliminated. Results:

tmpfs:    975 MB/sec
ntfs-3g:  889 MB/sec  (note, this FUSE driver is not optimized yet)
ext3:     675 MB/sec

> For someone who wants to migrate from Solaris to Linux,
> it might be useful, but I'm not sure you would really want to use a
> ZFS/FUSE implementation in production.

It seems the problem is that the only active ZFS-FUSE developer was 
hired by SUN and since then not much (visible) is happening.

Regards,  Szaka

--
NTFS-3G: http://ntfs-3g.org



