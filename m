From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 25/47] resize2fs: quickly rewrite extent blocks when
 moving an inode w/ metadata_csum
Date: Sat, 13 Dec 2014 22:09:41 -0500
Message-ID: <20141214030941.GN29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215329.883.82186.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54904 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaLNDJm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 22:09:42 -0500
Content-Disposition: inline
In-Reply-To: <20141107215329.883.82186.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:29PM -0800, Darrick J. Wong wrote:
> When we're moving an inode on a metadata_csum filesystem, we need to
> rewrite the checksum of all interior nodes of the extent tree.  The
> current code does this inefficiently via set_bmap, but we can do this
> more efficiently through direct iteration of the extent tree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
