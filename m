From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 46/74] e2fsck: try implied cluster allocation when
 expanding a dir
Date: Sun, 15 Dec 2013 23:56:03 -0500
Message-ID: <20131216045603.GI28536@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012327.30655.58116.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40379 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3LPE4F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Dec 2013 23:56:05 -0500
Content-Disposition: inline
In-Reply-To: <20131211012327.30655.58116.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:23:27PM -0800, Darrick J. Wong wrote:
> When we're expanding a directory, check to see if we're doing an
> implied cluster allocation; if so, we don't need to allocate a new
> block, and we certainly don't need to update the summary counts.
> 
> Reported-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
