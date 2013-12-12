From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/74] mke2fs: load configfile blocksize setting before
 64bit checks
Date: Thu, 12 Dec 2013 12:27:08 -0500
Message-ID: <20131212172708.GC13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011837.30655.67812.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39360 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab3LLR1Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:27:16 -0500
Content-Disposition: inline
In-Reply-To: <20131211011837.30655.67812.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:18:37PM -0800, Darrick J. Wong wrote:
> mke2fs has a series of checks to ensure that we don't create a
> filesystem too big for its blocksize -- if auto-64bit is on, then it
> turns on 64bit; otherwise it complains.  Unfortunately, it performs
> these checks before looking in mke2fs.conf for a blocksize, which
> means that the checks are incorrect if the user specifies a non-4096
> blocksize in the config file and says nothing on the command line.
> The bug also has the effect of mandating a 4k block size on any block
> device larger than 4T in that situation.  Therefore, read the block
> size from the config file before performing the 64bit checks.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
