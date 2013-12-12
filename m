From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/74] libext2fs: fix tests that set LARGE_FILE
Date: Thu, 12 Dec 2013 12:09:01 -0500
Message-ID: <20131212170901.GB13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011827.30655.19992.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39352 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab3LLRJF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:09:05 -0500
Content-Disposition: inline
In-Reply-To: <20131211011827.30655.19992.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:18:27PM -0800, Darrick J. Wong wrote:
> For each site where we test for a large file (> 2GB) and set the
> LARGE_FILE feature, use a helper function to make the size test
> consistent with the test that's in e2fsck.  This fixes the fsck
> complaints when we try to create a 2GB journal (not so hard with 64k
> block size) and fixes the incorrect test in fileio.c.
> 
> v2: Fix another site in e2fsck/pass2.c that Zheng Liu pointed out.

Thanks, applied.

					- Ted
