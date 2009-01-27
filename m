From: Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] root ext4 strange couldn't mount/can mount report
Date: Tue, 27 Jan 2009 09:14:26 -0500
Message-ID: <20090127141426.GC11843@mit.edu>
References: <20090127134231.6daf4cbb@sauron.linicks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nick Warne <nick@ukfsn.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59268 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZA0OOa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 09:14:30 -0500
Content-Disposition: inline
In-Reply-To: <20090127134231.6daf4cbb@sauron.linicks.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 27, 2009 at 01:42:31PM +0000, Nick Warne wrote:
> 
> Jan 27 12:54:57 sauron kernel: EXT3-fs: sda2: couldn't mount because of unsupported optional features (40).
> Jan 27 12:54:57 sauron kernel: VFS: Mounted root (ext4 filesystem) readonly.
> 
> i.e. root / -> /dev/sda2 couldn't mount, but it does mount, and system
> boots normally and functions fine.

That's normal; what happens is that the kernel tries to mount it as
ext3 first, which takes a pass since it can't support certain
filesystems features, and then ext4 mounts it.  The ext4 filesystem
code will happily mount an ext3 filesystem, so that's why the kernel
tries ext3 first.  The idea is that for people who are conservative,
and have some filesystems using ext3 and some using ext4 (to try out,
for example), and then they compile a kernel with both ext3 and ext4,
if the root filesystem only has ext3 features, it should be mounted
with ext3, not ext4; so the kernel tries ext3 first.  If however, you
do not compile in ext3 support, the ext4 filesystem code will happily
mount an ext3 filesystem --- and in the latest 2.6.29-rc series, the
ext4 filesystem code can even happily mount an ext2 filesystem.

You will get some of the advantages of ext4's delayed allocation
support with ext2/ext3 filesystems, and it would also allow you to
only have one extX filesystem compiled into the kernel.  But of
course, ext4 is still relatively new, and some people like to be
conservative with their filesystem choices, and so that's why it's
unlikely the ext3 filesystem code will be disappearing from the
kernel, even though the ext4 filesystem code is a superset of ext3's
functionality.

							- Ted

