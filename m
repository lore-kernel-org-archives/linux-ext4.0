From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/74] libext2fs: don't allow ridiculously large logical
 block numbers
Date: Thu, 12 Dec 2013 12:41:17 -0500
Message-ID: <20131212174117.GG13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011909.30655.58893.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39380 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab3LLRlU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:41:20 -0500
Content-Disposition: inline
In-Reply-To: <20131211011909.30655.58893.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:19:10PM -0800, Darrick J. Wong wrote:
> Forbid clients from trying to map logical block numbers that are
> larger than the lblk->pblk data structures are capable of handling.
> While we're at it, don't let clients set the file size to a number
> that's beyond what can be mapped.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
