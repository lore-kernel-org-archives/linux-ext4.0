From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: Porting Zfs features to ext2/3
Date: Thu, 31 Jul 2008 03:50:17 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0807310255280.32725@tamago.serverit.net>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto>
 <20080727233855.GB9378@mit.edu> <loom.20080729T222131-137@post.gmane.org>
 <20080730013427.GD29748@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tamago.serverit.net ([91.189.209.155]:45853 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753914AbYGaBOU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jul 2008 21:14:20 -0400
In-Reply-To: <20080730013427.GD29748@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 29 Jul 2008, Theodore Tso wrote:
> On Tue, Jul 29, 2008 at 10:52:26PM +0000, Szabolcs Szakacsits wrote:
> > I did also an in memory test on a T9300@2.5, with disk I/O completely 
> > eliminated. Results:
> > 
> > tmpfs:    975 MB/sec
> > ntfs-3g:  889 MB/sec  (note, this FUSE driver is not optimized yet)
> > ext3:     675 MB/sec
> 
> Am I write in guessing that this test involved copying a single large
> file, with no seeks?  

Yes, it was writing a large file on a newly created, loop mounted image 
file.

> What happens if you try benchmarking unpacking a kernel source tar.bz2 
> file?  My guess is that ntfs-3g won't look as good.  :-)

It seems the tar.bz2 number is not so bad relatively but the metadata 
performance difference is much more visible by eliminating the compression 
overhead. The results are in second.

              ext3    ntfs-3g
  tar.bz2      7.7      12.4
  tar.gz       3.1       8.7
  tar          1.4       7.6

A few seconds could be improved but I think getting similar numbers will 
need major FUSE changes and non-trivial work to get rid of most contexts 
switches which indeed seem to be the bottleneck according to the profiling 
data.

	Szaka

--
NTFS-3G:  http://ntfs-3g.org

