From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/21] e2fsck: do a better job of fixing i_size of inline
 directories
Date: Sun, 10 Aug 2014 18:44:21 -0400
Message-ID: <20140810224421.GB15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010642.2611.55743.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53526 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaHJWoW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:44:22 -0400
Content-Disposition: inline
In-Reply-To: <20140805010642.2611.55743.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:06:42PM -0700, Darrick J. Wong wrote:
> If we encounter a directory whose i_size != the inline data size, just
> set i_size to the size of the inline data.  The pb.last_block
> calculation is wrong since pb.last_block == -1, which results in
> i_size being set to zero, which corrupts the directory.
> 
> Clear the inline_data inode flag if we actually /are/ setting i_size
> to zero.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
