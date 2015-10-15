From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/8] ext2: only permit ro mounts with compat features we
 know we don't support
Date: Thu, 15 Oct 2015 10:37:28 -0400
Message-ID: <20151015143728.GG17329@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215437.28872.14707.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52026 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbbJOOha (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 10:37:30 -0400
Content-Disposition: inline
In-Reply-To: <20151012215437.28872.14707.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:54:37PM -0700, Darrick J. Wong wrote:
> The ext2 mount code never checks the compat features against the ones
> it knows about.  This is correct behavior since compat features are
> supposed to be rw-compatible with old drivers; however, for certain
> configurations (journalled rootfs) the admin is unlikely to want
> no-journal mode.  Since we changed the default probe order to put ext4
> first, we can make ext2.ko only allow readonly mounts if has_journal is
> found.
> 
> (Remember, this only affects mounting ext3 filesystems on ext2.ko.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm not sure that we need this patch.  If someone explicitly requests
a r/w mount of an ext3 file system using ext2, we should let it.
After changing the default probe order, the only time your change
would prohibit the mounting of an ext3 file system is when the system
administrator has explicitly mentioned the file system type in command
line.

						- Ted
