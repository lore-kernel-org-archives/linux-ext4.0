From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 24/74] dumpe2fs: check return values
Date: Thu, 12 Dec 2013 13:10:49 -0500
Message-ID: <20131212181049.GU13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012059.30655.24946.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39427 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3LLSKv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:10:51 -0500
Content-Disposition: inline
In-Reply-To: <20131211012059.30655.24946.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:20:59PM -0800, Darrick J. Wong wrote:
> Check the return values from ext2fs_get_block_bitmap_range2(); if an
> error happened, print that and don't print garbage bitmap.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
