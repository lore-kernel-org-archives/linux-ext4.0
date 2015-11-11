From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Date: Wed, 11 Nov 2015 11:26:28 -0800
Message-ID: <20151111192628.15056.6451.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com,
	linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
	linux-btrfs@vger.kernel.org
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

This is part of the third revision of an RFC for adding to XFS support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.

This patchset aims to make xfstests perform more rigorous testing of
the NFS/CIFS/ocfs2/btrfs/XFS file clone, reflink, and dedupe ioctls.
There are now tests of the basic functionality of the three ioctls;
tests to ensure that the filesystem exhibits the expected copy on
write semantics; tests to try to suss out race conditions in the new
write paths; tests to ensure that the ioctls peform basic disk
accounting correctly; tests of the interaction between reflink and the
various fallocate verbs (allocate, punch, collapse, insert zeroes);
and some attempts to test the upper limits of reflinking and ENOSPC
behavior.

Since the last posting, each test tries to reflink (or dedupe) on the
test or scratch FS to decide if they're going to run, instead of
guessing based on FS type.  Per Dave's suggestion, I also converted
the basic functionality tests to use fixed sizes so that I can use
md5sum in the golden output to check that the file contents match
exactly.

Issues: 

 * I think the race checks for dedupe could be a little sharper at
   finding mistakes.

 * The realtime reflink test (xfs/804) crashes XFS before we even get
   to the reflink attempt.

 * I started the numbering really high to prevent the tests from
   colliding with whatever new tests might arrive; this will require
   some intervention to fix.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3], and
xfs-docs[4].  They should just work with the btrfs that's in 4.3...
and somewhat buggily with the 4.3 XFS patched with [1].

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
