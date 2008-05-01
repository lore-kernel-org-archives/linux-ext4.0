From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH, RFC] ext3: move headers out of include/linux
Date: Thu, 1 May 2008 11:39:38 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0805011134520.5994@woody.linux-foundation.org>
References: <E1JrZxd-0004c8-7E@closure.thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764727AbYEASjv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2008 14:39:51 -0400
In-Reply-To: <E1JrZxd-0004c8-7E@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 1 May 2008, Theodore Ts'o wrote:
>
>  fs/ext3/acl.c              |    4 +-
>  fs/ext3/balloc.c           |    5 +-
>  fs/ext3/bitmap.c           |    2 +-
>  fs/ext3/dir.c              |    3 +-
>  fs/ext3/ext3.h             |  897 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext3/ext3_i.h           |  147 ++++++++
>  fs/ext3/ext3_jbd.c         |    7 +-
>  fs/ext3/ext3_jbd.h         |  225 +++++++++++
>  fs/ext3/ext3_sb.h          |   86 +++++
>  fs/ext3/file.c             |    5 +-
>  fs/ext3/fsync.c            |    5 +-
>  fs/ext3/hash.c             |    3 +-
>  fs/ext3/ialloc.c           |    5 +-
>  fs/ext3/inode.c            |    4 +-
>  fs/ext3/ioctl.c            |    5 +-
>  fs/ext3/namei.c            |    5 +-
>  fs/ext3/resize.c           |    6 +-
>  fs/ext3/super.c            |    5 +-
>  fs/ext3/symlink.c          |    3 +-
>  fs/ext3/xattr.c            |    4 +-
>  fs/ext3/xattr_security.c   |    4 +-
>  fs/ext3/xattr_trusted.c    |    4 +-
>  fs/ext3/xattr_user.c       |    5 +-
>  include/linux/ext3_fs.h    |  896 -------------------------------------------
>  include/linux/ext3_fs_i.h  |  147 --------
>  include/linux/ext3_fs_sb.h |   86 -----
>  include/linux/ext3_jbd.h   |  226 -----------

I'd suggest not sending out patches like this.

If the patch is largely a rename one, and sent out for review, just use 
"git diff -M -p --stat --summary", because it's going to be a *lot* more 
reviewable that way.

Yeah, it means that people need git to apply it, but by now we can 
probably take that for granted - and more importantly, even if they don't 
have git installed: when you send out of RFC, aren't you looking for 
commentary more than people to apply and test it?

And then the patch saying that it's a rename (with perhaps changes to the 
guard #ifdef thing) would be a lot more clear. Nobody is going to read a 
patch that is 2800 lines of mostly create/delete with presumably almost no 
actual changes?

		Linus
