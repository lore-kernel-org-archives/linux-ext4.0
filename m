From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3.3 0/2] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Date: Fri, 20 Nov 2015 16:50:01 -0800
Message-ID: <20151121005001.20398.92856.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
	Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

This is a small patch set against the reflink/dedupe test cases in
xfstests.  The first patch is a rewrite of the tools to find the
lowest vacant ID number and to move a test case.  These two programs
are useful for staging a lot of new tests at a high number and moving
them to lower numbers when the maintainer wants to accept the new
tests.

The second patch updates the golden output for the test that examines
the results of feeding bad inputs to the two ioctls.  The new error
values are based on a discussion of how to react to bad file types on
the mailing lists and the ongoing work to hoist the ioctls to the VFS
level.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3], and
xfs-docs[4].  They should just work with the btrfs that's in 4.3...
and somewhat buggily with the 4.3 XFS patched with [1].

(You don't need to pull the kernel or xfs-docs git trees if you're not
working on XFS reflink.  The relevant xfs_io support will be in
xfsprogs 4.3 and the tests were pulled into the xfstests-dev repo last
week.)

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
