From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] mke2fs: clean up kernel version tests
Date: Thu, 6 Feb 2014 15:28:28 -0500
Message-ID: <20140206202828.GK19884@thunk.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062151.20507.41042.stgit@birch.djwong.org>
 <20140121073240.GC1819@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54904 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbaBFU2b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 15:28:31 -0500
Content-Disposition: inline
In-Reply-To: <20140121073240.GC1819@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:32:40PM +0800, Zheng Liu wrote:
> On Mon, Jan 20, 2014 at 10:21:51PM -0800, Darrick J. Wong wrote:
> > Refactor the running kernel version checks to hide the details of
> > version code checking, etc.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
