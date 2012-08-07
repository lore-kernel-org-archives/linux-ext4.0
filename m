From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/36 v4] libext2fs: add inline_data file
Date: Tue, 7 Aug 2012 14:40:02 -0400
Message-ID: <20120807184002.GB29928@thunk.org>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
 <1343735309-30579-8-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43468 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab2HGSkG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2012 14:40:06 -0400
Content-Disposition: inline
In-Reply-To: <1343735309-30579-8-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One major comment about the library functions.  The reason why we have
functions of the form ext2fs_foo(), ext2fs_foo2(), ext2fs_foo3(),
etc. is to preserve backwards compatibility of the ABI.  In general,
ext2fs_foo2() will have an extra parameter which wasn't in
ext2fs_foo(), and ext2fs_foo2() will have a superset of the
functionality of ext2fs_foo().  If later we need to add to add another
parameter to further extend the functionality of the function, we
might have an ext2fs_foo3(), which again will be a supserset of the
functionality of ext2fs_foo2().   

So in general, we only need to implement ext2fs_fooN(), and then
ext2fs_fooX where 0 <= X <= N simply call ext2fs_fooN with the extra
parameters defaulted out (usually to 0 or NULL).

It also follows that when we create a new function, there's no need to
do this.  So the fact that you have an ext2fs_inlinedata_iterate()
which just calls ext2fs_inline_data_iterate2() is not something you
need to do.

More seriously, ext2fs_inline_data_iterate3() has an implementation
which is completely different from that of
ext2fs_inline_data_iterate2(), and that's an immediate red flag.  This
means that these two functions are semantically different, and so they
should have fundamentally different names --- or you need to make
ext2fs_inline_data_iterate3() a strict superset of the functionality
of ext2fs_inline_data_iterate2().

Also, I note that there are a number of patches which basically do
this:

-	retval = ext2fs_dir_iterate2(current_fs, inode_num, 0,
-				    0, rmdir_proc, &rds);
+	if (ext2fs_has_inline_data(current_fs, inode_num))
+		retval = ext2fs_inline_data_iterate2(current_fs, inode_num, 0,
+						     0, rmdir_proc, &rds);
+	else
+		retval = ext2fs_dir_iterate2(current_fs, inode_num, 0,
+					    0, rmdir_proc, &rds);

The much better thing to do is to make ext2fs_dir_iterate2() check to
see if the inode has inline data, and if so, to call
ext2fs_inline_data_iterate2() directly.   This has a couple of benefits.

The first is it will reduce the number of patches we need to apply.
More importantly, it means that existing programs that don't know
about inline data, but who happen to use ext2fs_dir_iterate(), will be
able to work automatically, without requiring code changes.  It's also
much cleaner from a conceptual point of view, since the
ext2fs_dir_iterate abstraction shouldn't need to expose to the user
whether the directory data is inline or in a separate data block.

Regards,

						- Ted
