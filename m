From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [Patch 6/13]  Allow more than 32000 subdirectories
Date: Sat, 4 Aug 2007 10:47:21 -0600
Message-ID: <20070804164720.GG6142@schatzie.adilger.int>
References: <1185275096.3789.71.camel@dhcp4.linsyssoft.com> <20070804135155.GB13758@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@clusterfs.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48041 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764185AbXHDQr0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Aug 2007 12:47:26 -0400
Content-Disposition: inline
In-Reply-To: <20070804135155.GB13758@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 04, 2007  09:51 -0400, Theodore Tso wrote:
> On Tue, Jul 24, 2007 at 04:34:56PM +0530, Girish Shilamkar wrote:
> > This patch includes the changes required to e2fsck to understand the 
> > nlink count changes made in the kernel. In pass2, while counting the 
> > links for a directory, if the link count exceeds 65000, its permanently 
> > set to EXT2_NLINK_MAXED (EXT2_LINK_MAX + 100). In pass4, when the 
> > counted and actual nlink counts are compared, e2fsck does not flag 
> > an error if counted links = EXT2_NLINK_MAXED and existing link count is 1. 
> 
> Has this actually been implemented in the kernel?  I don't think I've
> seen a patch which implements the a large number file links.  The
> 65000 subdir patch does *not* define EXT2_NLINK_MAXED, nor does this
> patch.   And this patch seems to use EXT2_LINK_MAX + 10, not +100.

I haven't tested hard-linked files myself, but they should remain with
a limit of EXT2_LINK_MAX.  It is only for directories that the link
count can be exceeded.  We have definitely tested with > 65000 subdirs.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
