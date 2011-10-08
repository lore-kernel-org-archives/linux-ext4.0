From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/28] ext4: Fix endian problem in MMP initialization
Date: Sat, 08 Oct 2011 00:54:16 -0700
Message-ID: <20111008075416.20506.12005.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:41694 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1JHH46 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:56:58 -0400
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
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

