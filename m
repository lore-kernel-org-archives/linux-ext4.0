From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/27] libext2fs: create inlinedata symlinks
Date: Sun, 24 Aug 2014 22:05:09 -0400
Message-ID: <20140825020509.GM6236@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234629.11171.85990.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Pu Hou <houpu.hp@alibaba-inc.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47196 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbaHYCFO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 22:05:14 -0400
Content-Disposition: inline
In-Reply-To: <20140816234629.11171.85990.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:29PM -0700, Darrick J. Wong wrote:
> Add to ext2fs_symlink the ability to create inline data symlinks.
> 
> Suggested-by: Pu Hou <houpu.hp@alibaba-inc.com>
> Cc: Pu Hou <houpu.hp@alibaba-inc.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This is identical to the already applied:

     http://patchwork.ozlabs.org/patch/378712/

							- Ted
