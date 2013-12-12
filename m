From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/74] libext2fs: fileio should use 64bit io routines
Date: Thu, 12 Dec 2013 12:50:25 -0500
Message-ID: <20131212175025.GL13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011954.30655.12129.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39398 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3LLRu1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:50:27 -0500
Content-Disposition: inline
In-Reply-To: <20131211011954.30655.12129.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:19:54PM -0800, Darrick J. Wong wrote:
> When reading or writing file blocks, use the IO manager routines that
> can handle 64bit block numbers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
