From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 35/74] libext2fs: zero block contents past EOF when
 setting size
Date: Thu, 12 Dec 2013 13:40:37 -0500
Message-ID: <20131212184037.GF13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012213.30655.39040.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39464 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3LLSkm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:40:42 -0500
Content-Disposition: inline
In-Reply-To: <20131211012213.30655.39040.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:13PM -0800, Darrick J. Wong wrote:
> When we set the file size, find the block containing EOF, and zero
> everything in that block past EOF so that we can't return stale data
> if we ever use fallocate or truncate to lengthen the file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
