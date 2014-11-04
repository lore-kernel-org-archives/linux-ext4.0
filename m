From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/39] tune2fs: speed up rewriting extent tree when
 enabling metadata_csum
Date: Tue, 4 Nov 2014 11:52:23 -0500
Message-ID: <20141104165223.GH30614@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205708.532.99186.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38346 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaKDQye (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:54:34 -0500
Content-Disposition: inline
In-Reply-To: <20141025205708.532.99186.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:57:08PM -0700, Darrick J. Wong wrote:
> When enabling checksums, tune2fs naively rewrites every extent in the
> entire tree!  This is unnecessary since we only need to rewrite each
> extent tree block; therefore, only rewrite the extent if it's the
> first one in an internal extent tree block.
> 
> Also, don't bother iterating the extent tree when clearing checksums.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
