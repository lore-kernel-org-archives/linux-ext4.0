From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v6] XFS TESTS: Add ENOSPC Punch Hole Test
Date: Mon, 27 Jun 2011 22:32:41 -0700
Message-ID: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

This is another set I sent out a while ago, but I didnt see it show up on the lists, 
so I am resending this one too. The work in this patch is a continuation from a 
previous patch set that has been partially accepted, so I thought I 
should retain the v6.

This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
This test will verify that a hole can be punched even when the disk is full.
Reserved blocks should be used to complete the operation when there is not blocks
to further fragment the file.

Because punching a hole does not always require extra blocks, there needs to 
be serveal iterations of punching holes, and then filling the file system to 100% 
usage before it is forced to grow the tree in order to handle the fragmentation. 
The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.

I could use some opinions on this patch set becuase I am not sure if other filesystems 
handle their punch holes in the same way.  Although xfs appears to pass the test, 
should this test be an ext4 only test? Thx!

Allison Henderson (2):
  XFS TESTS: Move su routines in 123 to common.rc
  XFS TESTS: Add ENOSPC Hole Punch Test

 123       |   24 ------------------------
 common.rc |   20 ++++++++++++++++++++
 group     |    1 +
 3 files changed, 21 insertions(+), 24 deletions(-)

