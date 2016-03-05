From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/12] reflink: fix fragmentation tests to work on >4k
 block size filesystems
Date: Sat, 5 Mar 2016 12:17:58 -0800
Message-ID: <20160305201758.GC10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003737.28738.35234.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160305003737.28738.35234.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
