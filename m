From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 45/74] e2fsck: print cluster ranges when encountering
 bitmap errors
Date: Sun, 15 Dec 2013 23:55:51 -0500
Message-ID: <20131216045551.GH28536@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012320.30655.87179.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40375 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3LPEzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Dec 2013 23:55:53 -0500
Content-Disposition: inline
In-Reply-To: <20131211012320.30655.87179.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:23:20PM -0800, Darrick J. Wong wrote:
> If pass5 finds bitmap errors in a range of clusters, don't print each
> cluster number individually when we could print only the start and end
> cluster number.  e2fsck already does this for the non-bigalloc case.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
