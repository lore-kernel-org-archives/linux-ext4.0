From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/74] e4defrag: defensively check results of
 sysconf(_SC_PAGESIZE)
Date: Thu, 12 Dec 2013 13:09:07 -0500
Message-ID: <20131212180907.GS13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012046.30655.22882.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39421 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3LLSJK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:09:10 -0500
Content-Disposition: inline
In-Reply-To: <20131211012046.30655.22882.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:20:46PM -0800, Darrick J. Wong wrote:
> sysconf(_SC_PAGESIZE) will probably never return an error, but just in
> case it does, we shouldn't pass what looks like a huge number to
> sync_file_range() and posix_fadvise().
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
