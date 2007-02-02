From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support
	for Ext4
Date: Thu, 01 Feb 2007 20:22:28 -0600
Message-ID: <1170382948.18617.30.camel@kleikamp.austin.ibm.com>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1>
	 <1170263470.12392.23.camel@kleikamp.austin.ibm.com>
	 <Pine.GSO.4.53.0702011200340.9072@compserv1>
	 <1170358339.12263.39.camel@kleikamp.austin.ibm.com>
	 <1170362491.4271.31.camel@localhost.localdomain>
	 <20070202014004.GB24328@mail.clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	Dave Kleikamp <shaggy@linux.external-vnet.ibm.com>,
	Nikolai Joukov <kolya@cs.sunysb.edu>,
	Harry Papaxenopoulos <harry@cs.sunysb.edu>,
	linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50148 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030196AbXBBCWe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 21:22:34 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l122MXpZ022702
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 21:22:33 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l122MXtV472770
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 19:22:33 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l122MXSD008782
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 19:22:33 -0700
In-Reply-To: <20070202014004.GB24328@mail.clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-02-01 at 18:40 -0700, Andreas Dilger wrote:
> On Feb 01, 2007  12:41 -0800, Mingming Cao wrote:
> > On Thu, 2007-02-01 at 19:32 +0000, Dave Kleikamp wrote:
> > > Yeah, I did see that.  I wonder adding some inode or file operation just
> > > to query the existence of those attributes (or something more generic)
> > > would be too ugly.
> > 
> > I gave a brief thought on that yesterday, it was not very pretty:)
> 
> Actually, the major filesystems (ext3, reiserfs, jfs, xfs) all use the
> same lsattr/chattr ioctl as ext2 (EXT2_IOC_GETFLAGS).  Maybe this code
> can just do an ioctl inside the kernel?

Al Viro will love that one.  :-)

Another idea might be to store those attribute flags in the generic
inode.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
