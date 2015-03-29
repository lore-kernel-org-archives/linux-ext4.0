From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/54] libext2fs: zero blocks via FALLOC_FL_ZERO_RANGE in
 ext2fs_zero_blocks
Date: Sat, 28 Mar 2015 23:46:11 -0400
Message-ID: <20150329034611.GE19097@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073750.13308.12929.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38571 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbbC2DqM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2015 23:46:12 -0400
Content-Disposition: inline
In-Reply-To: <20150127073750.13308.12929.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:50PM -0800, Darrick J. Wong wrote:
> Plumb a new call into the IO manager to support translating
> ext2fs_zero_blocks calls into the equivalent FALLOC_FL_ZERO_RANGE
> fallocate flag primitive when possible.  This patch provides _only_
> support for file-based images.
> 
> v2: Remove zero-out for block devices until BLKZEROOUT is cleaned up.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
