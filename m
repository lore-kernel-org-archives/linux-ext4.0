From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck: set dir_nlink feature if large dir exists
Date: Wed, 30 Aug 2017 11:13:32 -0400
Message-ID: <20170830151332.2ikr5dfox3aeebyd@thunk.org>
References: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
 <20170830022000.b7mgzksytvcwirx5@thunk.org>
 <604C57FC-C3A6-478F-BDA6-E8550555C70F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41822 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751332AbdH3PNe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 30 Aug 2017 11:13:34 -0400
Content-Disposition: inline
In-Reply-To: <604C57FC-C3A6-478F-BDA6-E8550555C70F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 30, 2017 at 01:43:30AM -0600, Andreas Dilger wrote:
> > The f_large_dir test is now failing after I apply this patch:
> > 
> > debugfs 1.43.6 (29-Aug-2017)
> > ./test_one: 38: /usr/projects/e2fsprogs/e2fsprogs/tests/f_large_dir/script: arithmetic expression: division by zero: "i / ELAPSED"
> > f_large_dir: optimize 3 level htree directories: failed
> 
> You must have a faster test system than I do...

I'm using a ramdisk for /tmp.  I suspect that's what is making all the
difference.  Otherwise it's just a normal Lenovo T470 laptop....

> On a related note, I was trying to implement the optimization for
> more efficient ext2fs_link() insertion, but this has proven to be
> much more complex than I expected.  I was thinking I would just
> call the link_proc() function directly to handle insertion of the
> new name, using block number of the previous caller.  However, this
> function depends on the directory leaf buffers having been read
> from disk, and being passed a dirent pointer to the free space after
> being called through a series of callback indirections.

I think it's more trouble than it's worth to preseve the existing
link_proc() function.  I'd recommend out to be just what is necessary
to do the directory entry insert, and make that a helper function
which is called by link_proc() and the shortcut handling code in
ext2fs_link().

Cheers,

						- Ted
