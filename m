From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 06:11:46 -0400
Message-ID: <20090515101146.GA6816@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu> <20090515045508.GA1279@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38728 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbZEOKL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 06:11:56 -0400
Content-Disposition: inline
In-Reply-To: <20090515045508.GA1279@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 10:25:08AM +0530, Aneesh Kumar K.V wrote:
> > commit 039ed7a483fdcb2dbbc29f00cd0d74c101ab14c5
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Thu May 14 17:09:37 2009 -0400
> > 
> >     ext4: Fix race in ext4_inode_info.i_cached_extent
> >     
> >     If one CPU is reading from a file while another CPU is writing to the
> >     same file different locations, there is nothing protecting the
> >     i_cached_extent structure from being used and updated at the same
> >     time.  This could potentially cause the wrong location on disk to be
> >     read or written to, including potentially causing the corruption of
> >     the block group descriptors and/or inode table.
> 
> 
> It should be multiple readers. We don't allow read/write or multiple
> writers via ext4_ext_get_blocks. &EXT4_I(inode)->i_data_sem is supposed
> to protect read/write and multiple writers. What it allowed was
> multiple readers(get_block call with create = 0). And readers did cache
> the extent information which it read from the disk. So the fix is
> correct, but we need to update the commit message.

Yes, you're right.  The i_data_sem would have protected us from the
worst of these problems.  The commit message isn't totally wrong,
though, since even a writer will call ext4_ext_get_blocks() with
create == 0.  But we should describe the failure mode much more
accurately, and say that it is two callers of ext4_ext_get_blocks()
with create=0 racing against one another.  It's possible, perhaps even
likely, that one of those callers came from a call of
ext4_get_blocks() with create=1 --- given that the people who were
reporting this were doing so when doing backup jobs.

However, one could imagine multiple mysql (or DB2) threads writing
into random parts of a database, and if two CPU's try to bmap already
allocated (and initialized) blocks out of the database file, so that
ext4_ext_get_blocks() is always being called with create=0, you could
very easily end up with a situation where blocks would be written to
the wrong location on disk.  <<shiver>>

We should make sure that all of the enterprise distributions that are
shipping ext4 as a "technology preview" get a copy of this patch as a
fixing a high-priority bug, since a database workload should trip this
pretty easily.

							- Ted
