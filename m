From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Wed, 7 Feb 2007 12:56:59 -0800
Message-ID: <20070207125659.bc27404d.akpm@linux-foundation.org>
References: <20070116210520sho@rifu.tnes.nec.co.jp>
	<20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
	<20070206173520.7719a7de.akpm@linux-foundation.org>
	<20070207204657.GC6565@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, sho@tnes.nec.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161153AbXBGU5i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Feb 2007 15:57:38 -0500
In-Reply-To: <20070207204657.GC6565@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 7 Feb 2007 13:46:57 -0700
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Feb 06, 2007  17:35 -0800, Andrew Morton wrote:
> > On Mon, 5 Feb 2007 14:12:04 +0100
> > Jan Kara <jack@suse.cz> wrote:
> > > > Move the blocks on the temporary inode to the original inode
> > > > by a page.
> > > > 1. Read the file data from the old blocks to the page
> > > > 2. Move the block on the temporary inode to the original inode
> > > > 3. Write the file data on the page into the new blocks
> > >   I have one thing - it's probably not good to use page cache for
> > > defragmentation.
> > 
> > Then it is no longer online defragmentation.  The issues with maintaining
> > correctness and coherency with ongoing VFS activity would be truly ghastly.
> > 
> > If we're worried about pagecache pollution then it would be better to control
> > that from userspace via fadvise().
> 
> It should be possible to have the online defrag tool lock the inode against
> any changes,

Sounds easy when you say it fast.  But how do we "lock" against, say, a
read pagefault?  Only by writing back then removing the pagecache page then
reinstantiating it as a locked, not-uptodate page and then removing it from
pagecache afterwards prior to unlocking it.  Or something.

I don't think we want to go there.

> flush all pages out of the cache for that inode, and then do
> the reallocated outside of the page cache.  For inodes not already in cache
> this is a no-op.  For the (hopefully rare) case were the inode already has
> cached pages and also needs to be reallocated it would be a performance hit.
> 
> Alternately, we could skip files currently being modified (or mmaped), or
> even recently modified (e.g. within the last 30 minutes) in the default case,
> on the assumption that they might be deleted soon anyways.

argh.

It's simple to just use pagecache.  The "we don't want to swamp the machine
with pagecache" argument is bogus.  If it becomes a problem (and it might
not) then it is very simple to control the pagecache from userspace.
