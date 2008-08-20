From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 12/15][e2fsprogs] Add ext2fs_div64_ceil()
Date: Wed, 20 Aug 2008 12:33:58 -0500
Message-ID: <20080820173358.23412.26392.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:55161 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYHTRdF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 13:33:05 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHX1px000815
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:33:02 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHWvu4143972
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:32:57 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHWvEh016964
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:32:57 -0600
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
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
index 38bca4d..99c2c5f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1415,6 +1415,14 @@ _INLINE_ unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b)
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
 

