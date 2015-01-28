From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/54] e2fsck: inspect inline dir data as two directory
 blocks
Date: Wed, 28 Jan 2015 10:16:24 -0500
Message-ID: <20150128151624.GQ2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073724.13308.48792.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42250 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbbA2CFs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jan 2015 21:05:48 -0500
Content-Disposition: inline
In-Reply-To: <20150127073724.13308.48792.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:24PM -0800, Darrick J. Wong wrote:
> The design of inline directories (apparently) calls for the i_block[]
> region and the EA regions to be treated as if they were two separate
> blocks of dirents.  Effectively this means that it is impossible for a
> directory entry to straddle both areas.  e2fsck doesn't enforce this,
> so teach it to do so.  e2fslib already knows to do this....
> 
> Cc: Zheng Liu <gnehzuil.liu@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
