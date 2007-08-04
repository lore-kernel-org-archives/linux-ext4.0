From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 4/13] Allow regular files to be preallocated on-disk.
Date: Sat, 4 Aug 2007 14:38:25 -0400
Message-ID: <20070804183825.GA11150@thunk.org>
References: <1185275088.3789.69.camel@dhcp4.linsyssoft.com> <20070804004013.GF7449@thunk.org> <20070804161943.GF6142@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@clusterfs.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47430 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761927AbXHDUi7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2007 16:38:59 -0400
Content-Disposition: inline
In-Reply-To: <20070804161943.GF6142@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 04, 2007 at 10:19:43AM -0600, Andreas Dilger wrote:
> On Aug 03, 2007  20:40 -0400, Theodore Tso wrote:
> > I'm also a little concerned this patch doesn't solve the problem where
> > a filesystem that had been previously mounted on an IA64 machine gets
> > connected to an x86 machine and then e2fsck is run.  This patch
> > doesn't make the problem any more worse, and to fix this for real
> > would require stashing the largest blocksize ever used by the
> > filesystem in the superblock, and I'm not entirely convinced it's
> > worth it.
> 
> At worst we get some warnings in that case and the extra blocks beyond
> EOF are removed.

Yep, that's why I said it's probably not worth it to worry about that
case.  It still bothers me a little, but that's the perfectionist in
me struggling to get out.  :-)

							- Ted
