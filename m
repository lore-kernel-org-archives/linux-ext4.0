From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] Add support for new compat feature "super_sparse"
Date: Thu, 16 Jan 2014 15:54:46 -0500
Message-ID: <20140116205446.GA12104@thunk.org>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu>
 <20140113132707.GA22358@orion.maiolino.org>
 <20140113140645.GC18029@thunk.org>
 <20140113161949.GB22541@thunk.org>
 <20140114055426.GB27083@thunk.org>
 <6C608D9A-AAAC-402D-BC7B-FC23EF9956BD@dilger.ca>
 <20140114160813.GA11232@thunk.org>
 <9E6FFD6C-D0E8-4B2D-A6F6-9835F6001786@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49158 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAPUyu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jan 2014 15:54:50 -0500
Content-Disposition: inline
In-Reply-To: <9E6FFD6C-D0E8-4B2D-A6F6-9835F6001786@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 16, 2014 at 01:21:47PM -0700, Andreas Dilger wrote:
> 
> I'm OK with this in theory, but it would make it harder to know what
> features are actually enabled, especially if "ext4_default_set" is
> changing over time.  Also, while this might be OK for "dumpe2fs"
> output, it shouldn't be used for the debugfs "features" command
> output, since that would break the ability to determine what features
> are actually implemented.

Yeah, I think if we were going to use sets, the sets would have to be
invariant over time.  So that probably means we'd have to do things
like ext4_set_v3, ext4_set_v4, etc.  And I think we'd want to have
options to both debugfs's "features" and commands to dumpe2fs which
either shows the full feature set, or the compressed version using
feature sets.  There are some interesting UI design issues hiding
here, which is one of the reasons I haven't pursued this seriously for
the past couple of years.

> > I'm not sure what what you mean by "conflict with the backup
> > descriptors in #0 and #1"?
> 
> In 4kB blocksize filesystems with 64-bit group descriptors, there
> are 64 group descriptors per block, so for the 32k blocks in group
> #0 this means a maximum of 32767 * 64 ~= 2M groups = 255TB before
> the group #0 group descriptors collide with the group #1 superblock
> and group #1 descriptor backups.

Ah.... yes, good point.  I suspect that we'd definitely want to use
bigalloc for a file system as big as 256TB, but still, this is
something we should try to fix in the future "sparse_super2" feature.

I wonder if the right answer is that we should have two fields in the
superblock which describes which block groups have the backup
superblocks, and then the tools which do automated searching for the
bitmaps would simply search the first couple of block groups looking
for the backup superblock.

If these fields is zero, then we can also skip having the backup
superblock --- which is actually what I'd probably use at Google,
because if the file system is that badly damaged, it's not worth it to
fix it.  Better to simply fix the file system by using mke2fs, and
relying on the redundancies at the cluster file system level.

	       		       	   - Ted
