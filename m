From: Theodore Tso <tytso@mit.edu>
Subject: How to fix up mballoc
Date: Thu, 23 Jul 2009 09:45:38 -0400
Message-ID: <20090723134538.GC8040@mit.edu>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34030 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZGWNqI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 09:46:08 -0400
Content-Disposition: inline
In-Reply-To: <4A67EE3F.4090909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I started looking to see how we might be able to improve mballoc to
avoid freespace fragmentation, and I came up with the following high
level design.  Does this look sane?   Have I overlooked anything?

1) In ext4_mb_normalize_request(), if the inode that we are allocating
does not have any open file descriptors for write (i.e., it's already
closed and we're allocating via delalloc) _and_ the inode was
previously opened with O_CREAT and without O_APPEND (checked via a
flag in EXT4_I(inode)), then do not normalize the size to a power of
two, but rather to the filesystem blocksize.

The idea here is that we should be trying to find an exact fit, since
most of the time (except for log files, which get appended; hence the
O_CREAT && !O_APPEND test) once a file is written, that is probably
the final size for the file.  So normalizing the size for the
preallocation area to a power of two will be counterproductive for
most files.

2) If the there has been less than X files opened in Y jiffies the
parent directory (using the dentry path used to open the file), then
do not set EXT4_MB_HINT_GROUP_ALLOC in ext4_mb_group_or_file().  We
can simulate this for without creating this patch to test #1 by
setting mb_stream_request to 0 (which should completely disable group
preallocation).

						- Ted
