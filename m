From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/25] libext2fs: report bad magic over bad sb checksum
Date: Thu, 11 Sep 2014 12:43:13 -0400
Message-ID: <20140911164313.GJ26178@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231149.25904.94554.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51440 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbaIKQnO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 12:43:14 -0400
Content-Disposition: inline
In-Reply-To: <20140908231149.25904.94554.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:11:49PM -0700, Darrick J. Wong wrote:
> We don't want ext2fs_open2() to report bad sb checksum on something
> that's not even an ext* superblock.  This apparently happens pretty
> easily if we try to open an XFS filesystem.  Thus, make it so that a
> bad magic number code always trumps the sb checksum error code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
