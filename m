From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] libext2fs: during punch, fix parent extents after
 modifying extent
Date: Thu, 6 Feb 2014 15:31:40 -0500
Message-ID: <20140206203140.GM19884@thunk.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062204.20507.93142.stgit@birch.djwong.org>
 <20140121074343.GE1819@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54912 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaBFUbm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 15:31:42 -0500
Content-Disposition: inline
In-Reply-To: <20140121074343.GE1819@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:43:43PM +0800, Zheng Liu wrote:
> On Mon, Jan 20, 2014 at 10:22:04PM -0800, Darrick J. Wong wrote:
> > When modifying/removing an extent during punch, don't forget to update
> > the extent's parents.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
