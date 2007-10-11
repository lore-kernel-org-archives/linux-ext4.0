From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 11/13][e2fsprogs] Fix test cases.
Date: Thu, 11 Oct 2007 14:17:06 -0500
Message-ID: <20071011191706.4599.4215.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:46648 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbXJKTQy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 15:16:54 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJGrXZ012578
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:53 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJGrHX456826
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:53 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJGrh5025217
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:53 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJGqfX025199
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:53 -0600
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJGqaX037932
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:52 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Fix test cases.

Some of the tools outputs have changed, so this patch fixes what to expect
from the outputs of the f_dupfsblks and m_raid_opt test cases.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
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
