From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck: set dir_nlink feature if large dir exists
Date: Tue, 29 Aug 2017 22:20:00 -0400
Message-ID: <20170830022000.b7mgzksytvcwirx5@thunk.org>
References: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39378 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751669AbdH3CUD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Aug 2017 22:20:03 -0400
Content-Disposition: inline
In-Reply-To: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 18, 2017 at 12:19:42PM -0600, Andreas Dilger wrote:
> If there is a directory with more than EXT2_LINK_MAX (65000)
> subdirectories, but the DIR_NLINK feature is not set in the
> superblock, the feature should be set before continuing on
> to change the on-disk directory link count to 1.
> 
> While most filesystems should have DIR_NLINK set (it was set
> by default for all ext4 filesystems, and the kernel before
> 4.12 automatically set it if the directory link count grew
> too large), it is possible that this flag is lost due to disk
> corruption or for an upgraded filesystem.  We no longer want
> the kernel to automatically enable this feature.
> 
> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=196405
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

The f_large_dir test is now failing after I apply this patch:

debugfs 1.43.6 (29-Aug-2017)
./test_one: 38: /usr/projects/e2fsprogs/e2fsprogs/tests/f_large_dir/script: arithmetic expression: division by zero: "i / ELAPSED"
f_large_dir: optimize 3 level htree directories: failed

						- Ted
