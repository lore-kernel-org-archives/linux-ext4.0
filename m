From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/47] tune2fs: enable uninit_bg when disabling
 metadata_csum
Date: Sat, 13 Dec 2014 21:58:46 -0500
Message-ID: <20141214025846.GJ29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215303.883.11462.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54868 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaLNC6s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 21:58:48 -0500
Content-Disposition: inline
In-Reply-To: <20141107215303.883.11462.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:03PM -0800, Darrick J. Wong wrote:
> If we're disabling metadata_csum and the user doesn't provide explicit
> instructions to enable or disable uninit_bg, assume that they want
> uninit_bg to be turned on by default.  Otherwise, we lose all block
> group flags and unused inode count, which is a big hit to performance.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
