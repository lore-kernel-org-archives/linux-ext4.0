From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] xfs/073: fix output
Date: Sat, 5 Mar 2016 12:22:18 -0800
Message-ID: <20160305202218.GG10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003803.28738.34407.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160305003803.28738.34407.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixes one warning for my config, but adds two new ones (see below).
Looks like we need to do some better feature detection.


--- tests/xfs/073.out	2016-03-03 07:55:58.556427678 +0000
+++ /root/xfstests/results//xfs/073.out.bad	2016-03-05 20:21:07.368100504 +0000
@@ -1,6 +1,4 @@
 QA output created by 073
-warning: finobt not supported without CRC support, disabled.
-warning: rmapbt not supported without CRC support, disabled.
 warning: reflink not supported without CRC support, disabled.
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
 data     = bsize=XXX blocks=XXX, imaxpct=PCT
@@ -38,6 +36,7 @@
 unmounting and removing new image
 
 === copying scratch device to single target, large ro device
+warning: reflink not supported without CRC support, disabled.
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
 data     = bsize=XXX blocks=XXX, imaxpct=PCT
          = sunit=XXX swidth=XXX, unwritten=X
@@ -51,6 +50,7 @@
 checking new image
 mounting new image on loopback
 comparing new image files to old
+File /mnt/test/23382.source_dir/xfstests/dev is a block special file while file /mnt/test/23382.loop/xfstests/dev is a block special file
 comparing new image directories to old
 comparing new image geometry to old
 unmounting and removing new image
