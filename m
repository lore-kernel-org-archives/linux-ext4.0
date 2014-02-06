From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] libext2fs: try to roll back when splitting an extent
 fails
Date: Thu, 6 Feb 2014 15:34:29 -0500
Message-ID: <20140206203429.GN19884@thunk.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062217.20507.51789.stgit@birch.djwong.org>
 <20140121074946.GG1819@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54916 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaBFUeb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 15:34:31 -0500
Content-Disposition: inline
In-Reply-To: <20140121074946.GG1819@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:49:46PM +0800, Zheng Liu wrote:
> On Mon, Jan 20, 2014 at 10:22:17PM -0800, Darrick J. Wong wrote:
> > If a client asks us to remap a block in the middle of an extent, we
> > potentially have to allocate a fair number of blocks to handle extent
> > tree splits.  A failure in either of the ext2fs_extent_insert calls
> > leaves us with an extent tree that no longer maps the logical block in
> > question and everything that came after it!  Therefore, try to roll
> > back the extent tree changes before returning an error code.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

						- Ted
