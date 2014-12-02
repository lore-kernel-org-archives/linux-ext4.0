From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents
 traversial
Date: Tue, 2 Dec 2014 18:07:30 -0500
Message-ID: <20141202230730.GH13618@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
 <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35599 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbaLBXHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 18:07:31 -0500
Content-Disposition: inline
In-Reply-To: <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2014 at 03:00:54PM +0400, Dmitry Monakhov wrote:
> It is rediculus practice to scan inode block by block, this technique
> applicable only for old indirect files. This takes signifficant amount
> of time for really large files. Let's reuse ext4_fiemap which already
> traverse inode-tree in most optimal meaner.
> 
> TESTCASE:
> ftruncate64(fd, 0);
> ftruncate64(fd, 1ULL << 40);
> /* lseek will spin very long time */
> lseek64(fd, 0, SEEK_DATA);
> lseek64(fd, 0, SEEK_HOLE);

Thanks, applied.

						- Ted
