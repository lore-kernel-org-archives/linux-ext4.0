From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 10/30] libext2fs: define new dirent_swab interfaces
 for inline data
Date: Mon, 3 Mar 2014 10:49:50 -0500
Message-ID: <20140303154950.GB9620@thunk.org>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
 <1386323897-2354-11-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36406 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbaCCPt5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2014 10:49:57 -0500
Content-Disposition: inline
In-Reply-To: <1386323897-2354-11-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 06, 2013 at 05:57:57PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Later we will use ext2fs_dirent_swab_in/out to handle big-endian problem
> for inline data.  Now interfaces assume that it handles a block, but it
> is not true after adding inline data.  So this commit defines a new
> interface for inline data.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
