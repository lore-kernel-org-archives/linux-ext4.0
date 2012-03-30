From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 30 Mar 2012 13:57:26 +0100
Message-ID: <20120330125726.GA26221@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sami.liedes@iki.fi>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760011Ab2C3M5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Mar 2012 08:57:37 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[I'm tracking this issue here:
https://bugzilla.redhat.com/show_bug.cgi?id=808421]

febootstrap uses the ext2fs library to construct an ext2 filesystem.

Since we updated to the latest version in git, febootstrap segfaults
in ext2fs_find_first_zero_generic_bmap (called from ext2fs_new_inode).
There's a complete stack trace in the bug above.

I'm not claiming that we are calling this library correctly, but,
you know, "it always worked until now".

Here is the calling code:

https://github.com/libguestfs/febootstrap/blob/636a80b5a70382f21da47c44a0acd3efa2bc7fcf/helper/ext2.c#L142

git bisect points to this change being the one which causes the
problem:

c1a1e7fc24d6e37f931bbb8eeb29c90243f0a55d is the first bad commit
commit c1a1e7fc24d6e37f931bbb8eeb29c90243f0a55d
Author: Sami Liedes <sami.liedes@iki.fi>
Date:   Sat Mar 10 22:36:12 2012 +0200

    libext2fs: Implement ext2fs_find_first_zero_generic_bmap().
    
    This function searches a bitmap for the first zero bit within a range.
    It checks if there is a bitmap backend specific implementation
    available (if the relevant field in bitmap_ops is non-NULL). If not,
    it uses a generic and slow method by repeatedly calling test_bmap() in
    a loop. Also change ext2fs_new_inode() to use this new function.
    
    This change in itself does not result in a large speedup, rather it
    refactors the code in preparation for the introduction of a faster
    find_first_zero() for bitarray based bitmaps.
    
    Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
