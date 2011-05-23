From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: xfsprogs: Fix for xfstest 252 hang on ext4
Date: Mon, 23 May 2011 13:34:55 -0700
Message-ID: <4DDAC4EF.1050702@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50076 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1EWUfJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 16:35:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4NKRve6032220
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:27:57 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p4NKZ6ut142608
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:35:06 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4NKZ6N6001499
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:35:06 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

While trying to add more punch hole tests to xfstest, I found that test 252 hangs on ext4 due to a loop in xfsprogs that does not exit.  XFS gets out of this loop because there is logic in the loop that looks for the last extent flag and breaks out.  But it looks like ext4 does not return a last extent when the file has a hole at the end.  I am not sure if this is the correct behavior or not, so I will copy the ext4 folks on this too.  Below is a copy of the fix for xfsprogs:

diff --git a/io/fiemap.c b/io/fiemap.c
index fa990cc..81fc92c 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -246,7 +246,7 @@ fiemap_f(
 		       flg_w, _("FLAGS"));
 	}
 
-	while (!last && ((cur_extent + 1) != max_extents)) {
+	while (!last && (cur_extent <= max_extents)) {
 		if (max_extents)
 			num_extents = min(num_extents,
 					  max_extents - (cur_extent + 1));


It looks like the loop enters with last=0, cur_extents=0, and max_extents = 0, and on the first iteration cur_extents get set to 2, so we dont see ((cur_extent + 1) == max_extents for a very long time.  I doubt the logic was meant to work that way, so this patch should fix it, but I wanted to make sure that the fiemap for ext4 is working as intended too.  Feed back appreciated!  Thx all!

Allison Henderson
