From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/21] e2fsck: don't set prev after processing '..' on an
 inline dir
Date: Sun, 10 Aug 2014 18:50:54 -0400
Message-ID: <20140810225054.GF15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010709.2611.18449.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53554 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaHJWu4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:50:56 -0400
Content-Disposition: inline
In-Reply-To: <20140805010709.2611.18449.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:07:09PM -0700, Darrick J. Wong wrote:
> In an inline directory, the '..' entry is compacted down to just the
> inode number; there is no full '..' entry.  Therefore, it makes no
> sense to assign 'prev' to the fake dotdot entry we put on the stack,
> as this could confuse a salvage_directory call on a corrupted next
> entry into modifying stack contents (the fake dotdot entry).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
