From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 09:07:33 -0400
Message-ID: <20090515130732.GD9173@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu> <20090515045508.GA1279@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57134 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027AbZEONHk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 09:07:40 -0400
Content-Disposition: inline
In-Reply-To: <20090515045508.GA1279@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 10:25:08AM +0530, Aneesh Kumar K.V wrote:
> So the fix is correct, but we need to update the commit message.

Here's the updated commit message.

						- Ted

ext4: Fix race in ext4_inode_info.i_cached_extent

If two CPU's simultaneously call ext4_ext_get_blocks() at the same
time, there is nothing protecting the i_cached_extent structure from
being used and updated at the same time.  This could potentially cause
the wrong location on disk to be read or written to, including
potentially causing the corruption of the block group descriptors
and/or inode table.

This bug has been in the ext4 code since almost the very beginning of
ext4's development.  Fortunately once the data is stored in the page
cache cache, ext4_get_blocks() doesn't need to be called, so trying to
replicate this problem to the point where we could identify its root
cause was *extremely* difficult.  Many thanks to Kevin Shanahan for
working over several months to be able to reproduce this easily so we
could finally nail down the cause of the corruption.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
