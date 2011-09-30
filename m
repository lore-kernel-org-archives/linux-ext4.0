From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext4: Fix comparison endianness problem in MMP
	initialization
Date: Fri, 30 Sep 2011 12:49:00 -0700
Message-ID: <20110930194900.GY12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45451 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab1I3Tsx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Sep 2011 15:48:53 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As part of startup, the MMP initialization code does this:

mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());

Next, mmp->mmp_seq is written out to disk, a delay happens, and then the MMP
block is read back in and the sequence value is tested:

if (seq != le32_to_cpu(mmp->mmp_seq)) {
	/* fail the mount */

On a LE system such as x86, the *le32* functions do nothing and this works.
Unfortunately, on a BE system such as ppc64, this comparison becomes:

if (cpu_to_le32(new_seq) != le32_to_cpu(cpu_to_le32(new_seq)) {
	/* fail the mount */

Except for a few palindromic sequence numbers, this test always causes the
mount to fail, which makes MMP filesystems generally unmountable on ppc64.  The
attached patch fixes this situation.

(This fix came up while testing the metadata checksumming patchset)

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/mmp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 9bdef3f..a7a4986 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -295,7 +295,8 @@ skip:
 	/*
 	 * write a new random sequence number.
 	 */
-	mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());
+	seq = mmp_new_seq();
+	mmp->mmp_seq = cpu_to_le32(seq);
 
 	retval = write_mmp_block(bh);
 	if (retval)
