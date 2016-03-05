From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/12] xfs/23[3-6]: don't source common/xfs, it doesn't
 exist
Date: Sat, 5 Mar 2016 12:19:09 -0800
Message-ID: <20160305201909.GD10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003743.28738.8245.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160305003743.28738.8245.stgit@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 04, 2016 at 04:37:43PM -0800, Darrick J. Wong wrote:
> Don't source common/xfs, since it doesn't (yet) exist.

Heh.  Wonder how they ever worked before..
(they probably didn't, and I didn't notice as I never ran with rmapbt)

Reviewed-by: Christoph Hellwig <hch@lst.de>
