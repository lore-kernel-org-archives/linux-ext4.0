From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of
 directory inodes
Date: Wed, 2 Oct 2013 12:23:23 -0400
Message-ID: <20131002162323.GB31579@thunk.org>
References: <20131001160817.GA2295@kvack.org>
 <20131002144759.GB32181@quack.suse.cz>
 <524C3574.7020106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41321 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab3JBQX3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 12:23:29 -0400
Content-Disposition: inline
In-Reply-To: <524C3574.7020106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 02, 2013 at 10:02:12AM -0500, Eric Sandeen wrote:
> One thing I'm curious about - what changed from ext3 to ext4?  I thought
> both defaulted to orlov and the same type of allocation behavior, more
> or less.  I guess one change is that the "oldalloc" mount
> option went away.

Ext3 used an orlov style allocator as well.  The main difference
between ext4 and ext3 is the orlov allocator is now done on a
per-flexbg basis instead of per-blockgroup basis.

That is, we do the statistics based on a flex-bg basis instead of the
blockgroup basis.  As a result, I suspect Ben would see the inode
allocation behavior equivalent to ext3 if he creates the file system
using "mke2fs -t ext4 -G 1" to force the flex_bg size to 1.

Can you let me know what the size of the file system was, and mke2fs
parameters you were using for ext3 and ext4?  I have a feeling that
inode allocations weren't optimal for your use case even with ext3,
but because we now spread the inodes based on flex_bg's instead of
block groups, that's why you saw the performance degredation.

      	      	     	     	     - Ted
