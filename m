From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 08:50:35 -0400
Message-ID: <20090515125035.GC9173@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu> <4A0CC381.3080804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55465 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZEOMum (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 08:50:42 -0400
Content-Disposition: inline
In-Reply-To: <4A0CC381.3080804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 08:21:05PM -0500, Eric Sandeen wrote:
> 
> it should lay out a 4g file in random 1m direct IOs to fragment it and
> get a lot of extents, then launch 2 threads, one each doing random reads
> and random writes of that same file.
> 
> I can't make this trip it, though ...

If all of the blocks are in the page cache, you won't end up calling
ext4_get_blocks().  Try adding a shell script which runs in parallel
doing a "while /bin/true ; do sleep 1; echo 3 > /proc/sys/vm/drop_cache; done".

							- Ted
