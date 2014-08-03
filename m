From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/19] e2fsck: always ask to fix an inode that fails
 checksum verification
Date: Sat, 2 Aug 2014 22:55:39 -0400
Message-ID: <20140803025539.GL24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181300.12496.48122.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41979 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbaHCCzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:55:42 -0400
Content-Disposition: inline
In-Reply-To: <20140801181300.12496.48122.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:13:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If an inode fails checksum verification during pass 1 and the user
> doesn't fix or clear the inode as part of the regular inode checks,
> ensure that e2fsck remembers to ask the user if he simply wants to
> correct the checksum.
> 
> We weren't capturing all the ways out of an interation of the inode
> scanning loop, which means that not all errors were caught.  Also,
> we might as well clear the 'failed csum' flag if we write the inode
> directly from the inode scanning loop.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
