From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 27/47] resize2fs: don't interpret bitmap shift while
 crossing flexbg as raid stride
Date: Sun, 14 Dec 2014 21:11:08 -0500
Message-ID: <20141215021108.GC17575@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215341.883.6602.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55839 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaLOCLI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 21:11:08 -0500
Content-Disposition: inline
In-Reply-To: <20141107215341.883.6602.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:41PM -0800, Darrick J. Wong wrote:
> resize2fs tries to infer the RAID stride by observing differences between the
> locations of adjacent block groups' block and inode bitmaps within the block
> group.  If the two block groups being compared belong to different flexbgs,
> however, it'll be fooled by the large offset into thinking that the FS has an
> abnormally large RAID stride.
> 
> Therefore, teach it not to get confused by crossing a flexbg.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: TR Reardon <thomas_reardon@hotmail.com>

Applied, thanks.

						- Ted
