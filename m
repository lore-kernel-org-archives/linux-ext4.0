From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/4 v3] XFS TESTS: Fix 252 failure
Date: Wed, 29 Jun 2011 22:23:57 -0700
Message-ID: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch corrects a 252 test failure when run on ext4.  This failure
occures because ext4 and xfs do not handle splitting extents in the same way, 
and do not create the same fiemap outout.

To correct this, this patch set will make test 252 an xfs only test, and a new 
test 255 will be added.  The new test is similar to 252, but uses a weaker fiemap filter
that only shows the location of the hole, and not the extent type.  An
md5 check sum has also been added to the tests to help ensure the contents are
correct.

Also, another patch was submitted that modifies the same code in 242.out.
Assuming that patch will go through, this set was modified to be applied on 
top of Christoph's "[PATCH] xfstests: update test 042 golden output" (06/20/2011). 

I noticed there are some other patches that are trying to add a test 255, so we 
may need another version of this set depending on which ones go in first.

Allison Henderson (4):
  XFS TESTS: Fix 252 Failure: Make 252 xfs only with MD5 checksum
  XFS TESTS: Fix 252 Failure: Update 252 Golden Output
  XFS TESTS: Fix 252 Failure: Update 242 Golden Output
  XFS TESTS: Fix 252 Failure: Add Generic FS Punch Hole Test 255

 242.out      |   17 +++
 252          |    2 +-
 252.out      |   68 +++++++++++++
 255          |   67 +++++++++++++
 255.out      |  307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.punch |   40 ++++++++
 group        |    1 +
 7 files changed, 501 insertions(+), 1 deletions(-)
 create mode 100644 255
 create mode 100644 255.out

