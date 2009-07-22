From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Wed, 22 Jul 2009 16:10:14 -0700
Message-ID: <1248304214.14463.17.camel@bobble.smo.corp.google.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:12084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZGVXKg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jul 2009 19:10:36 -0400
In-Reply-To: <20090721215421.GM4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-07-21 at 15:54 -0600, Andreas Dilger wrote:
> No, that isn't correct.  The intent of KEEP_SIZE is to allow fallocate
> to preallocate blocks beyond the EOF, so that it doesn't affect the
> file data visible to userspace, but can avoid fragmentation from e.g.
> log files or mbox files.
> 
> The i_disksize variable is just to handle the lag in updating the on-disk
> file size during truncate, because the VFS updates i_size to indicate a
> truncate, but in order to handle the truncation of files within finite
> transaction sizes the on-disk file size needs to be shrunk incrementally.
> 
> The difference is that i_size is in the VFS inode, and represents the
> current in-memory state, while i_disksize is in the ext4 private inode
> data and represents what is currently in the on-disk inode.

Okay, this makes sense, thanks.

> That said, we might need to have some kind of flag in the on-disk
> inode to indicate that it was preallocated beyond EOF.  Otherwise,
> e2fsck will try and extend the file size to match the block count,
> which isn't correct.  We could also use this flag to determine if
> truncate needs to be run on the inode even if the new size is the
> same.

After chatting with Curt about this today, it sounds like this needs two
things.  One is your flag in the on-disk inode, set in fallocate() to
indicate that it has an allocation past EOF.  E2fsck would use this to
avoid "fixing" the file size to match the block count.  Truncate would
use this to notice that there are blocks allocated past i_size and get
rid of them.  It would be cleared by truncate or by ext4_get_blocks when
using the last block of such an allocation.

Does this make sense?  Have I missed anything?

> As a workaround for now, you could truncate to (size+1), then again
> truncate to (size) and it should have the desired effect.

Well, as bad as fallocate()/truncate() is, doing two truncates is worse,
I think.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

