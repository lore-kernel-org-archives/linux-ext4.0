From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 28/47] resize2fs: set bg flags and unused inode count
 when resizing
Date: Sun, 14 Dec 2014 21:12:58 -0500
Message-ID: <20141215021258.GD17575@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215348.883.19810.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55851 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaLOCM6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 21:12:58 -0500
Content-Disposition: inline
In-Reply-To: <20141107215348.883.19810.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:48PM -0800, Darrick J. Wong wrote:
> Recalculate the unused inode count and the block/inode uninit flags
> when resizing a filesystem.  This can speed up future e2fsck runs
> considerably and will reduce mount times.
> 
> v2: Use a library function to take care of this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
