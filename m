From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Porting Zfs features to ext2/3
Date: Tue, 29 Jul 2008 21:34:27 -0400
Message-ID: <20080730013427.GD29748@mit.edu>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu> <loom.20080729T222131-137@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:36806 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbYG3BfI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 21:35:08 -0400
Content-Disposition: inline
In-Reply-To: <loom.20080729T222131-137@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:52:26PM +0000, Szabolcs Szakacsits wrote:
> I did also an in memory test on a T9300@2.5, with disk I/O completely 
> eliminated. Results:
> 
> tmpfs:    975 MB/sec
> ntfs-3g:  889 MB/sec  (note, this FUSE driver is not optimized yet)
> ext3:     675 MB/sec

Am I write in guessing that this test involved copying a single large
file, with no seeks?  What happens if you try benchmarking unpacking a
kernel source tar.bz2 file?  My guess is that ntfs-3g won't look as
good.  :-)

						- Ted
