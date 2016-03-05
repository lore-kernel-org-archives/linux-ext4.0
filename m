From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/12] xfs/030: fix output on newer filesystems
Date: Sat, 5 Mar 2016 12:20:50 -0800
Message-ID: <20160305202050.GF10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003756.28738.26362.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160305003756.28738.26362.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Still fails for me:

--- tests/xfs/030.out	2016-03-03 07:55:58.556427678 +0000
+++ /root/xfstests/results//xfs/030.out.bad	2016-03-05 20:20:17.561433837 +0000
@@ -231,8 +231,6 @@
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
-bad agbno AGBNO in agfl, agno 0
-bad agbno AGBNO in agfl, agno 0
         - found root inode chunk
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
