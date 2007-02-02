From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support for Ext4
Date: Thu, 1 Feb 2007 18:40:04 -0700
Message-ID: <20070202014004.GB24328@mail.clusterfs.com>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1> <1170263470.12392.23.camel@kleikamp.austin.ibm.com> <Pine.GSO.4.53.0702011200340.9072@compserv1> <1170358339.12263.39.camel@kleikamp.austin.ibm.com> <1170362491.4271.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Nikolai Joukov <kolya@cs.sunysb.edu>,
	Harry Papaxenopoulos <harry@cs.sunysb.edu>,
	linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58334 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423064AbXBBBkE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 20:40:04 -0500
Content-Disposition: inline
In-Reply-To: <1170362491.4271.31.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 01, 2007  12:41 -0800, Mingming Cao wrote:
> On Thu, 2007-02-01 at 19:32 +0000, Dave Kleikamp wrote:
> > > Unfortunately, we need some file system-specific code to access per-file
> > > secure deletion and per-file trash bit attributes.  These attributes are
> > > supported only by some file systems and in different ways.  
> 
> The check for fs specific attributes has to be underlying fs code.  But
> the code the handling the secure delete and trash bin (although now is
> only two functions being called) are identical for all fs, could be move
> to VFS layer.
> 
> > Yeah, I did see that.  I wonder adding some inode or file operation just
> > to query the existence of those attributes (or something more generic)
> > would be too ugly.
> 
> I gave a brief thought on that yesterday, it was not very pretty:)

Actually, the major filesystems (ext3, reiserfs, jfs, xfs) all use the
same lsattr/chattr ioctl as ext2 (EXT2_IOC_GETFLAGS).  Maybe this code
can just do an ioctl inside the kernel?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
