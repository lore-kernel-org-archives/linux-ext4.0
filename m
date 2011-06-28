From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/3 v2] XFS TESTS: Fix 252 failure
Date: Mon, 27 Jun 2011 21:27:24 -0700
Message-ID: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

Sorry for the delay on this set.  I meant to send it a while back,
but it looks like the email did not get through, so I am resending it. 

This patch corrects a 252 test failure when run on ext4.  Becuase ext4
and xfs do not handle splitting extents in the same way, it was decided
that the fiemap filter should not display an extent type. Only the
location of the hole.  An md5 check sum has also been added to make 
sure the file contents are correct.

Also, another patch was sumbitted that modifes the same code in 242.out.
Assumeing that patch will go through, this set was modifed to be applied on 
top of Christoph's "[PATCH] xfstests: update test 042 golden output" (06/20/2011). 

Allison Henderson (3):
  XFS TESTS: Fix 252 Failure: Relax fiemap filter
  XFS TESTS: Fix 252 Failure: Update 252 Golden Output
  XFS TESTS: Fix 252 Failure: Update 242 Golden Output

 242.out      |   17 ++++
 252          |    8 +-
 252.out      |  272 ++++++++++++++++++++++++++++++++++++----------------------
 common.punch |   38 ++++++++-
 4 files changed, 227 insertions(+), 108 deletions(-)

