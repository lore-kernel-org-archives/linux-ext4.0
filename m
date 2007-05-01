From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext2/3 block remapping tool
Date: Tue, 1 May 2007 00:01:42 -0600
Message-ID: <20070501060142.GZ5967@schatzie.adilger.int>
References: <20070426192953.GC2841@duck.suse.cz> <20070427180942.GB5967@schatzie.adilger.int> <20070430120930.GA10604@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38242 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946598AbXEAGTq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 May 2007 02:19:46 -0400
Content-Disposition: inline
In-Reply-To: <20070430120930.GA10604@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 30, 2007  08:09 -0400, Theodore Tso wrote:
> On Fri, Apr 27, 2007 at 12:09:42PM -0600, Andreas Dilger wrote:
> > I'd prefer that such functionality be integrated with Takashi's online
> > defrag tool, since it needs virtually the same functionality.  For that
> > matter, this is also very similar to the block-mapped -> extents tool
> > from Aneesh.  It doesn't make sense to have so many separate tools for
> > users, especially if they start interfering with each other (i.e. defrag
> > undoes the remapping done by your tool).
> 
> While we're at it, someone want to start thinking about on-line
> shrinking of ext4 filesystems?  Again, the same block remapping
> interfaces for defrag and file access optimizations should also be
> useful for shrinking filesystems (even if some of the files that need
> to be relocated are being actively used).  If not, that probably means
> we got the interface wrong.

Except one other issue with online shrinking is that we need to move
inodes on occasion and this poses a bunch of other problems over just
remapping the data blocks.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
