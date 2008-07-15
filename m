From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 12/15][e2fsprogs] Add ext2fs_div64_ceil()
Date: Tue, 15 Jul 2008 11:51:13 -0500
Message-ID: <20080715165112.28567.58826.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60330 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbYGOQvP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 12:51:15 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGpEil031214
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:14 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGpEGA178420
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:14 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGpDKV009256
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:14 -0400
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add ext2fs_div64_ceil()

Add a new div_cell routine able to handle 64bit values

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0ca978b..3bc866e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1409,6 +1409,14 @@ _INLINE_ unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b)
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
+_INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
+{
+	if (!a)
+		return 0;
+	return ((a - 1) / b) + 1;
+}
+
 #undef _INLINE_
 #endif
 

