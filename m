From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix dir_nlink behaviour
Date: Sat, 5 Aug 2017 19:53:06 -0400
Message-ID: <20170805235306.diur6x753xbk4b3f@thunk.org>
References: <1500677367-82142-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, eggert@cs.ucla.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41172 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbdHEXxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 5 Aug 2017 19:53:10 -0400
Content-Disposition: inline
In-Reply-To: <1500677367-82142-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 21, 2017 at 04:49:27PM -0600, Andreas Dilger wrote:
> The dir_nlink feature has been enabled by default for new ext4
> filesystems since e2fsprogs-1.41 in 2008, and was automatically
> enabled by the kernel for older ext4 filesystems since the
> dir_nlink feature was added with ext4 in kernel 2.6.28+ when
> the subdirectory count exceeded EXT4_LINK_MAX.
> 
> We shouldn't really be enabling filesystem features automatically,
> as this prevents the administrator from disabling the feature at
> format time, or via tune2fs.  This should not affect many users by
> this point, but allows limiting subdirectory counts to those that
> can strictly fit into i_links_count rather than using "1" to
> indicate that the number of links on the directory is not tracked.
> This avoids a bug in glibc fts_read() that incorrectly optimizes
> the directory traversal for such directories.
> 
> This also addresses a minor bug in ext4_inc_count() where i_nlinks
> was wrapped at (EXT4_LINK_MAX - 1) links rather than allowing the
> full EXT4_LINK_MAX links on the parent directory (including "."
> and "..") before storing i_links_count = 1.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=196405
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
