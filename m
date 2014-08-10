From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 15/21] e2fsck: fix conflicting extents|inlinedata
 inode flags
Date: Sun, 10 Aug 2014 18:43:18 -0400
Message-ID: <20140810224318.GA15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010635.2611.19661.stgit@birch.djwong.org>
 <20140808162429.GB11191@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53518 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaHJWnU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:43:20 -0400
Content-Disposition: inline
In-Reply-To: <20140808162429.GB11191@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 09:24:29AM -0700, Darrick J. Wong wrote:
> If we come across an inode with the inline data and extents inode flag
> set, try to figure out the correct flag settings from the contents of
> i_block and i_size.  If i_blocks looks like an extent tree head, we'll
> make it an extent inode; if it's small enough for inline data, set it
> to that.  This leaves the weird gray area where there's no extent
> tree but it's too big for the inode -- if /could/ be a block map,
> change it to that; otherwise, just clear the inode.
> 
> v2: Don't add unnecessary variables.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
