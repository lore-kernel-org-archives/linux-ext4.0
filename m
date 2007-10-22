From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 12/14] Fix test cases.
Date: Sun, 21 Oct 2007 21:04:13 -0500
Message-ID: <20071022020413.23849.39911.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:58987 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXJVCHj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:07:39 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M27dd2009808
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:07:39 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M27dD4112784
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:39 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M27dmT009109
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:39 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M27c5U009102
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:38 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Fix test cases.

Some of the tools outputs have changed, so this patch fixes what to expect
from the outputs of the f_dupfsblks and m_raid_opt test cases.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
--

 tests/f_dupfsblks/expect.1 |    3 ++-
 tests/m_raid_opt/expect.1  |   33 ++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/tests/f_dupfsblks/expect.1 b/tests/f_dupfsblks/expect.1
index 661e164..32ce89b 100644
--- a/tests/f_dupfsblks/expect.1
+++ b/tests/f_dupfsblks/expect.1
@@ -44,7 +44,8 @@ Salvage? yes
 Directory inode 12, block 3, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (12) has deleted/unused inode 32.  Clear? yes
+Entry '' in ??? (12) has a zero-length name.
+Clear? yes
 
 Directory inode 12, block 4, offset 100: directory corrupted
 Salvage? yes
diff --git a/tests/m_raid_opt/expect.1 b/tests/m_raid_opt/expect.1
index 44c5b46..f5abc37 100644
--- a/tests/m_raid_opt/expect.1
+++ b/tests/m_raid_opt/expect.1
@@ -46,57 +46,68 @@ Setting filetype for entry '..' in ??? (11) to 2.
 Directory inode 11, block 1, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1063.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 2, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1064.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 3, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1065.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 4, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1066.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 5, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1067.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 6, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1068.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 7, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1069.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 8, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1070.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 9, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1071.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 10, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1072.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 11, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1073.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Pass 3: Checking directory connectivity
 '..' in / (2) is <The NULL inode> (0), should be / (2).
