From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v5 00/12] xfstests: minor fixes for the reflink/dedupe tests
Date: Fri, 04 Mar 2016 16:37:18 -0800
Message-ID: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a patch set for xfstests, associated with the fifth revision
to a patch series adding reverse mapping and reflink to XFS.  Patches
1, 3-9, and 11 are bug fixes to existing reflink tests.

Patches 2 and 10 add a few more XFS-specific reflink tests to ensure
that we get the CoW and metadata reservation accounting correct.

Patch 12 adds tests for the new block device fallocate call; don't
bother merging it unless the corresponding kernel patches aren't
shouted down after a reasonable amount of time.

Comments and questions are, as always, welcome.  The fixes are
available on github[1].

--D

[1] https://github.com/djwong/xfstests/tree/reflink-devel
