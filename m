From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/74] debugfs: don't leak fd when calling dump_file
Date: Thu, 12 Dec 2013 12:51:30 -0500
Message-ID: <20131212175130.GM13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012007.30655.55062.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39401 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3LLRvd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:51:33 -0500
Content-Disposition: inline
In-Reply-To: <20131211012007.30655.55062.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:20:07PM -0800, Darrick J. Wong wrote:
> The caller of dump_file provides a fd to write to, so the caller
> should also dispose of the fd.  Also, the fd never gets closed if
> preserve=1.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

				- Ted
