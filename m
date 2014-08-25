From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/27] libext2fs: fix problems with LE<->BE conversions
 on BE platforms
Date: Sun, 24 Aug 2014 22:01:58 -0400
Message-ID: <20140825020158.GK6236@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234616.11171.78225.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47179 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbaHYCCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 22:02:00 -0400
Content-Disposition: inline
In-Reply-To: <20140816234616.11171.78225.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:16PM -0700, Darrick J. Wong wrote:
> Fix more problems that I found when testing on ppc64:
> 
> - Inode swap cut and paste error leads to immutable inodes being
>   detected as inlinedata inodes, leading to e2fsck incorrectly barfing
>   on i_block[] contents.
> 
> - Superblock csum/verify must be aware of the fs->super byte order
>   when checking for metadata_csum feature flag.  (Hint: in _openfs(),
>   fs->super is in LE order for the first csum verification)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
