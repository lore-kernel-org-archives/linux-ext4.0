From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Can't resize2fs - combination of flex_bg and !resize_inode
Date: Mon, 20 Aug 2012 23:02:45 -0400
Message-ID: <20120821030245.GA4222@thunk.org>
References: <0FB0C67C-CF56-4589-857F-8B57BC25AB7D@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curtis Jones <curtis.jones@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45960 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab2HUDC7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2012 23:02:59 -0400
Content-Disposition: inline
In-Reply-To: <0FB0C67C-CF56-4589-857F-8B57BC25AB7D@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 20, 2012 at 03:18:35AM -0400, Curtis Jones wrote:
> Hi. I hope this is the right list for ext4-related user questions. If not, please point me in the right direction.
> 
> I recently set up my first software raid with mdadm and after adding more disks to the raid I am unable to resize the filesystem to the full size of the raid. I created a single (~16TB) filesystem on /dev/md0 via:
> 
> 	mkfs.ext4 -v -b 4096 -t huge -E stride=128,stripe-width=256 /dev/md0

This is wrong.  It should have been

mke2fs -v -b 4096 -t ext4 -T huge -E stride=128,stripe-width=256 /dev/md0

Unfortunately -t huge overrode the ".ext4" in "mkfs.ext4", leading to
an incorrect set of file system options.  I didn't expect people would
try to use do this.  I'll have to improve mke2fs's error handling to
prevent the -t/-T confusion.

That being said, you must have a non-standard /etc/mke2fs.conf file,
since when I tried your command line, here's the file system features
that I ended up with:

Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super large_file

This wouldn't have given you any of ext4's advanced features, but
resize2fs should have worked in that case.

Can you send me the output of "dumpe2fs -h /dev/md0", and your
/etc/mke2fs.conf file?

> While I await any suggestions, I'm going to look at a more
> up-to-date versions of these tools. Please let me know if I need to
> provide any more information. I *really* would like to find out that
> there's a way to resize the fs without having to recreate the
> fs. Copying all of this data off and back on would be painful.

Yes, you should definitely get a newer version of e2fsprogs.  The
latest version is 1.42.5.

As to whether you'll need to recreate the filesystem, I'll need to see
the output of dumpe2fs -h.  It may be that file system was created in
sufficiently poor configuration that it would be highly advisable that
you recreate the file system.

My apologies for the confusion with the options parsing.  Originally
the goal was to allow new fs-types (ext2/ext3/ext4) specified with -t,
and new usage-types (huge/big/small/etc.) specified with -T, to be
defined via new stanzas in /etc/mke2fs.conf.  The problem came when we
also added backwards compatibility support for argv[0] being set to
mkfs.<fs-type>.

That's not something I normally use --- I normally use mke2fs and
e2fsck directly --- and so it didn't occur to me that there would be
confusion if someone confused -t and -T while using an argv[0] of
mkfs.ext4.

Regards,

						- Ted
