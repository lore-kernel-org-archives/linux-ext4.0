From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 40/74] libext2fs: no need to clear BLOCK_UNINIT during
 ext2fs_reserve_super_and_bgd
Date: Sat, 11 Jan 2014 14:18:26 -0500
Message-ID: <20140111191826.GF1582@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012246.30655.88212.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47581 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaAKTSg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 14:18:36 -0500
Content-Disposition: inline
In-Reply-To: <20131211012246.30655.88212.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:46PM -0800, Darrick J. Wong wrote:
> Since the beginning of the uninit_bg feature, the kernel[1] and
> e2fsck[2] have always been careful to detect the presence of the
> BLOCK_UNINIT flag, and compute a block bitmap with any group metadata
> blocks marked in that bitmap.  With that in mind, I think it's safe to
> say that this is a design feature of uninit_bg.
> 
> Now that we've trained libext2fs to have this same behavior whenever
> it's loading a block bitmap, we no longer need to unset BLOCK_UNINIT
> for a group that contains only its own group metadata -- kernel,
> e2fsck, and e2fsprogs will handle this correctly.
> 
> [1] kernel git 717d50e4971b81b96c0199c91cdf0039a8cb181a
>     "Ext4: Uninitialized Block Groups"
> [2] e2fsprogs git f5fa20078bfc05b554294fe9c5505375d7913e8c
>     "Add support for EXT2_FEATURE_COMPAT_LAZY_BG"
> 
> Reported-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
