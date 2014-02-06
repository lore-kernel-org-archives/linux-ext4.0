From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] libext2fs: iterate past lower extents during punch
Date: Thu, 6 Feb 2014 15:29:59 -0500
Message-ID: <20140206202959.GL19884@thunk.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062158.20507.50066.stgit@birch.djwong.org>
 <20140121074011.GD1819@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54908 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbaBFUaA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 15:30:00 -0500
Content-Disposition: inline
In-Reply-To: <20140121074011.GD1819@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:40:11PM +0800, Zheng Liu wrote:
> On Mon, Jan 20, 2014 at 10:21:58PM -0800, Darrick J. Wong wrote:
> > When we're iterating extents during a punch operation, the loop exits
> > if the punch region is entirely to the right of the extent we're
> > looking at.  This can happen if the punch region starts in the middle
> > of a hole and covers mapped extents.  When this happens, we want to
> > skip to the next extent, because it might be punchable.
> > 
> > Also, if we've totally passed the punch range, stop.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
