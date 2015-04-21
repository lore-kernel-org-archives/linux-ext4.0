From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/35] e2fsck: track directories to be rehashed with a
 bitmap
Date: Tue, 21 Apr 2015 10:06:16 -0400
Message-ID: <20150421140616.GF3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023433.25243.88338.stgit@birch.djwong.org>
 <20150421022645.GC3238@thunk.org>
 <20150421044345.GF11592@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50117 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbbDUOGS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2015 10:06:18 -0400
Content-Disposition: inline
In-Reply-To: <20150421044345.GF11592@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 20, 2015 at 09:43:45PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 20, 2015 at 10:26:45PM -0400, Theodore Ts'o wrote:
> > On Wed, Apr 01, 2015 at 07:34:33PM -0700, Darrick J. Wong wrote:
> > > Use a bitmap to track which directories we want to rehash, since
> > > bitmaps will use less memory.  This enables us to clean up the
> > > rehash-all case to use inode_dir_map, and we can free the dirinfo
> > > memory sooner.
> > 
> > Using inode_dir_map for the rehash-all case is a good idea, but I'm
> > not sure it follows that we should ues a bitmap for the non-rehash-all
> > case.
> 
> Eh, you're right, let's drop this one.  Honestly it's been so long I don't
> remember my motivation for writing this up in the first place.  Thanks for
> pulling in the e2fsck readahead pieces, though!

I think there still is value in using inode_dir_map to iterate over
all of the directories, so we can free the dirinfo memory sooner, but
the value is not as great, I agree.

					- Ted
